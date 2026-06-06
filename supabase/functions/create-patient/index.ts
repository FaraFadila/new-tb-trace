import { createClient } from "@supabase/supabase-js";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type CreatePatientRequest = {
  full_name?: string;
  phone?: string;
  address?: string;
  guardian_name?: string;
  guardian_phone?: string;
  guardian_address?: string;
  kelurahan?: string;
  latitude?: number;
  longitude?: number;
  treatment_start_date?: string;
  treatment_end_date?: string;
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

function randomDigits(length: number) {
  const values = new Uint8Array(length);
  crypto.getRandomValues(values);
  return Array.from(values, (value) => String(value % 10)).join("");
}

function temporaryPassword() {
  return `TbTrace!${randomDigits(6)}`;
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

  const { data: callerProfile, error: profileError } = await admin
    .from("profiles")
    .select("role")
    .eq("id", caller.id)
    .single();

  if (profileError) {
    return json({ error: profileError.message }, 500);
  }

  if (!["healthcare", "admin"].includes(callerProfile.role)) {
    return json({ error: "Only healthcare users can create patients" }, 403);
  }

  const payload = (await req.json()) as CreatePatientRequest;
  const fullName = payload.full_name?.trim();

  if (!fullName) {
    return json({ error: "Patient name is required" }, 400);
  }

  const patientCode = `PT-${randomDigits(6)}`;
  const temporaryPass = temporaryPassword();
  const patientEmail = `${patientCode.toLowerCase()}@patients.tb-trace.local`;

  const { data: createdUser, error: createUserError } =
    await admin.auth.admin.createUser({
      email: patientEmail,
      password: temporaryPass,
      email_confirm: true,
      user_metadata: {
        full_name: fullName,
        role: "patient",
        phone: payload.phone ?? null,
        username: patientCode,
      },
    });

  if (createUserError || !createdUser.user) {
    return json(
      { error: createUserError?.message ?? "Failed to create patient user" },
      400,
    );
  }

  const patientUserId = createdUser.user.id;

  const { error: profileUpdateError } = await admin
    .from("profiles")
    .update({
      full_name: fullName,
      role: "patient",
      phone: payload.phone ?? null,
      username: patientCode,
    })
    .eq("id", patientUserId);

  if (profileUpdateError) {
    await admin.auth.admin.deleteUser(patientUserId);
    return json({ error: profileUpdateError.message }, 500);
  }

  const { data: patient, error: patientError } = await admin
    .from("patients")
    .insert({
      patient_code: patientCode,
      user_id: patientUserId,
      healthcare_id: caller.id,
      full_name: fullName,
      phone: payload.phone ?? null,
      address: payload.address ?? null,
      guardian_name: payload.guardian_name ?? null,
      guardian_phone: payload.guardian_phone ?? null,
      guardian_address: payload.guardian_address ?? null,
      login_email: patientEmail,
      temporary_password: temporaryPass,
      kelurahan: payload.kelurahan ?? null,
      latitude: payload.latitude ?? null,
      longitude: payload.longitude ?? null,
      treatment_start_date: payload.treatment_start_date ?? null,
      treatment_end_date: payload.treatment_end_date ?? null,
    })
    .select("id, patient_code, full_name")
    .single();

  if (patientError) {
    await admin.auth.admin.deleteUser(patientUserId);
    return json({ error: patientError.message }, 500);
  }

  return json({
    patient,
    credentials: {
      email: patientEmail,
      username: patientCode,
      temporary_password: temporaryPass,
    },
  });
});
