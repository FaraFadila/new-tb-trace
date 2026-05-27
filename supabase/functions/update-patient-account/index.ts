import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type UpdatePatientAccountRequest = {
  full_name?: string;
  email?: string;
  password?: string | null;
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

function stringOrNull(value: unknown) {
  if (typeof value !== "string") return null;

  const text = value.trim();
  return text.length === 0 ? null : text;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !serviceRoleKey) {
    return json({ error: "Supabase environment is not configured" }, 500);
  }

  const authorization = req.headers.get("Authorization");
  const token = authorization?.replace("Bearer ", "");

  if (!token) {
    return json({ error: "Missing authorization token" }, 401);
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });

  const { data: userData, error: userError } = await admin.auth.getUser(token);
  const caller = userData.user;

  if (userError || !caller) {
    return json({ error: "Invalid authorization token" }, 401);
  }

  const payload = (await req.json()) as UpdatePatientAccountRequest;
  const fullName = stringOrNull(payload.full_name);
  const email = stringOrNull(payload.email);
  const password = stringOrNull(payload.password);

  if (!fullName) {
    return json({ error: "Name is required" }, 400);
  }

  if (!email || !email.includes("@")) {
    return json({ error: "Valid email is required" }, 400);
  }

  if (password !== null && password.length < 6) {
    return json({ error: "Password must be at least 6 characters" }, 400);
  }

  const { data: profile, error: profileError } = await admin
    .from("profiles")
    .select("role, username, phone")
    .eq("id", caller.id)
    .single();

  if (profileError || !profile) {
    return json({ error: profileError?.message ?? "Profile was not found" }, 404);
  }

  const authUpdates: {
    email?: string;
    password?: string;
    user_metadata: Record<string, unknown>;
  } = {
    email,
    user_metadata: {
      ...(caller.user_metadata ?? {}),
      full_name: fullName,
      role: profile.role,
      phone: profile.phone ?? caller.user_metadata?.phone ?? null,
      username: profile.username ?? caller.user_metadata?.username ?? null,
    },
  };

  if (password !== null) {
    authUpdates.password = password;
  }

  const { data: updatedUser, error: updateUserError } =
    await admin.auth.admin.updateUserById(caller.id, authUpdates);

  if (updateUserError || !updatedUser.user) {
    return json(
      { error: updateUserError?.message ?? "Failed to update auth account" },
      400,
    );
  }

  const { error: updateProfileError } = await admin
    .from("profiles")
    .update({
      full_name: fullName,
      updated_at: new Date().toISOString(),
    })
    .eq("id", caller.id);

  if (updateProfileError) {
    return json({ error: updateProfileError.message }, 500);
  }

  if (profile.role === "patient") {
    const credentialChanged = email !== caller.email || password !== null;
    const patientUpdates: Record<string, unknown> = {
      login_email: email,
      updated_at: new Date().toISOString(),
    };

    if (credentialChanged) {
      patientUpdates.temporary_password = null;
    }

    const { error: updatePatientError } = await admin
      .from("patients")
      .update(patientUpdates)
      .eq("user_id", caller.id);

    if (updatePatientError) {
      return json({ error: updatePatientError.message }, 500);
    }
  }

  return json({
    email: updatedUser.user.email,
    full_name: fullName,
    password_changed: password !== null,
  });
});
