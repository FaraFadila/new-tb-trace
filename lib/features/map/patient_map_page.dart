import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../core/services/patient_service.dart';
import '../../core/widgets/app_user_header.dart';
import '../../core/widgets/patient_bottom_navbar.dart';

class PatientMapPage extends StatefulWidget {
  const PatientMapPage({super.key});

  @override
  State<PatientMapPage> createState() => _PatientMapPageState();
}

class _PatientMapPageState extends State<PatientMapPage> {
  static const _LatLng _surabayaCenter = _LatLng(-7.2575, 112.7521);
  static const int _mapZoom = 15;
  static const int _tileSize = 256;
  static const int _tileRadius = 3;
  static const Map<String, _LatLng> _knownSurabayaPlaces = {
    'keputih': _LatLng(-7.2946, 112.8031),
    'gubeng': _LatLng(-7.2729, 112.7555),
    'sukolilo': _LatLng(-7.2953, 112.7819),
    'mulyorejo': _LatLng(-7.2632, 112.7899),
    'rungkut': _LatLng(-7.3306, 112.7794),
    'gunung anyar': _LatLng(-7.3395, 112.7894),
    'wonokromo': _LatLng(-7.3023, 112.7397),
    'wonocolo': _LatLng(-7.3247, 112.7375),
    'tenggilis': _LatLng(-7.3205, 112.7545),
    'gayungan': _LatLng(-7.3378, 112.7244),
    'jambangan': _LatLng(-7.3226, 112.7131),
    'karang pilang': _LatLng(-7.3388, 112.6871),
    'wiyung': _LatLng(-7.3086, 112.6857),
    'lakarsantri': _LatLng(-7.3109, 112.6441),
    'dukuh pakis': _LatLng(-7.2872, 112.7032),
    'tegalsari': _LatLng(-7.2761, 112.7348),
    'genteng': _LatLng(-7.2605, 112.7468),
    'bubutan': _LatLng(-7.2518, 112.7335),
    'simokerto': _LatLng(-7.2458, 112.7521),
    'tambaksari': _LatLng(-7.2517, 112.7645),
    'kenjeran': _LatLng(-7.2326, 112.7852),
    'bulak': _LatLng(-7.2244, 112.7935),
    'semampir': _LatLng(-7.2197, 112.7467),
    'pabean cantian': _LatLng(-7.2327, 112.7379),
    'krembangan': _LatLng(-7.2359, 112.7204),
    'asemrowo': _LatLng(-7.2469, 112.6942),
    'sawahan': _LatLng(-7.2698, 112.7138),
    'sambikerep': _LatLng(-7.2754, 112.6552),
    'pakal': _LatLng(-7.2224, 112.6213),
    'benowo': _LatLng(-7.2294, 112.6508),
  };

  final PatientService _patientService = PatientService();
  final TransformationController _mapController = TransformationController();
  late final Future<_PatientMapLocation> _patientLocationFuture;
  String? _centeredMapKey;

  @override
  void initState() {
    super.initState();
    _patientLocationFuture = _loadPatientLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<_PatientMapLocation> _loadPatientLocation() async {
    final patient = await _patientService.getCurrentPatientDetail();
    final address = _stringOrNull(patient.address);

    if (address == null) {
      return _setResolvedPatientLocation(
        _PatientMapLocation(
          patient: patient,
          coordinate: _surabayaCenter,
          isApproximate: true,
        ),
      );
    }

    for (final query in _addressQueries(address)) {
      try {
        final locations = await locationFromAddress(query);

        if (locations.isNotEmpty) {
          final location = locations.first;
          return _setResolvedPatientLocation(
            _PatientMapLocation(
              patient: patient,
              coordinate: _LatLng(location.latitude, location.longitude),
              isApproximate: query != address,
            ),
          );
        }
      } catch (_) {
        continue;
      }
    }

    return _setResolvedPatientLocation(
      _PatientMapLocation(
        patient: patient,
        coordinate: _knownCoordinateFor(address) ?? _surabayaCenter,
        isApproximate: true,
      ),
    );
  }

  Iterable<String> _addressQueries(String address) sync* {
    final seen = <String>{};

    String? add(String value) {
      final text = value.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (text.isEmpty) return null;
      if (!seen.add(text.toLowerCase())) return null;
      return text;
    }

    final lowerAddress = address.toLowerCase();
    final fullAddress =
        lowerAddress.contains('surabaya') ? address : '$address, Surabaya';
    final completeAddress =
        fullAddress.toLowerCase().contains('indonesia')
            ? fullAddress
            : '$fullAddress, Jawa Timur, Indonesia';

    final complete = add(completeAddress);
    if (complete != null) yield complete;

    if (lowerAddress.contains('surabaya')) {
      final original = add(address);
      if (original != null) yield original;
      if (!lowerAddress.contains('indonesia')) {
        final withCountry = add('$address, Indonesia');
        if (withCountry != null) yield withCountry;
      }
    }

    for (final part in address.split(RegExp(r'[,;\n]'))) {
      final cleanPart = _cleanAddressPart(part);
      if (cleanPart == null) continue;

      final query = add('$cleanPart, Surabaya, Jawa Timur, Indonesia');
      if (query != null) yield query;
    }

    for (final place in _knownSurabayaPlaces.keys) {
      if (lowerAddress.contains(place)) {
        final query = add('$place, Surabaya, Jawa Timur, Indonesia');
        if (query != null) yield query;
      }
    }

    final original = add(address);
    if (original != null) yield original;
  }

  _PatientMapLocation _setResolvedPatientLocation(
    _PatientMapLocation location,
  ) {
    return location;
  }

  String? _cleanAddressPart(String value) {
    final text =
        value
            .trim()
            .replaceAll(
              RegExp(r'\b(no|nomor|rt|rw)\.?\b', caseSensitive: false),
              ' ',
            )
            .replaceAll(RegExp(r'\d+'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();

    if (text.length < 4) return null;
    return text;
  }

  _LatLng? _knownCoordinateFor(String address) {
    final lowerAddress = address.toLowerCase();

    for (final entry in _knownSurabayaPlaces.entries) {
      if (lowerAddress.contains(entry.key)) return entry.value;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: const Color(0xFFF8FAFA),
      bottomNavigationBar: const PatientBottomNavbar(currentIndex: 1),
      body: FutureBuilder<_PatientMapLocation>(
        future: _patientLocationFuture,
        builder: (context, snapshot) {
          final patientLocation = snapshot.data;

          return Stack(
            children: [
              Positioned.fill(child: _buildMap(patientLocation)),
              _buildLiveBadge(),
              _buildMapControls(),
              if (snapshot.connectionState == ConnectionState.waiting)
                _buildLoadingCard()
              else if (snapshot.hasError)
                _buildMessageCard(
                  title: 'Lokasi belum tersedia',
                  message: 'Data pasien belum bisa dimuat.',
                  icon: Icons.location_off_outlined,
                )
              else if (patientLocation != null)
                _buildPatientPopup(patientLocation),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppUserHeader(
                  horizontalPadding: 24,
                  profileRoute: '/profile-patient',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(_PatientMapLocation? patientLocation) {
    final coordinate = patientLocation?.coordinate ?? _surabayaCenter;
    final tileLayout = _TileLayout.forCoordinate(coordinate);

    return LayoutBuilder(
      builder: (context, constraints) {
        _centerMapOnce(tileLayout, constraints.biggest);

        return InteractiveViewer(
          transformationController: _mapController,
          constrained: false,
          minScale: 0.75,
          maxScale: 4,
          boundaryMargin: const EdgeInsets.all(1600),
          panEnabled: true,
          scaleEnabled: true,
          child: SizedBox(
            width: tileLayout.size,
            height: tileLayout.size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (
                  int x = tileLayout.startTileX;
                  x <= tileLayout.endTileX;
                  x++
                )
                  for (
                    int y = tileLayout.startTileY;
                    y <= tileLayout.endTileY;
                    y++
                  )
                    Positioned(
                      left: (x - tileLayout.startTileX) * _tileSize.toDouble(),
                      top: (y - tileLayout.startTileY) * _tileSize.toDouble(),
                      width: _tileSize.toDouble(),
                      height: _tileSize.toDouble(),
                      child: Image.network(
                        'https://tile.openstreetmap.org/$_mapZoom/$x/$y.png',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Container(color: const Color(0xFFEFF3EF)),
                      ),
                    ),
                Positioned(
                  left: tileLayout.markerOffset.dx - 26,
                  top: tileLayout.markerOffset.dy - 26,
                  child: _buildPatientMarkerIcon(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _centerMapOnce(_TileLayout tileLayout, Size viewportSize) {
    final mapKey =
        '${tileLayout.center.latitude.toStringAsFixed(6)}-${tileLayout.center.longitude.toStringAsFixed(6)}';

    if (_centeredMapKey == mapKey || viewportSize == Size.zero) return;

    _centeredMapKey = mapKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _mapController.value =
          Matrix4.identity()..translateByDouble(
            viewportSize.width / 2 - tileLayout.markerOffset.dx,
            viewportSize.height / 2 - tileLayout.markerOffset.dy,
            0,
            1,
          );
    });
  }

  Widget _buildPatientMarkerIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF006E1C), width: 2),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(alpha: 0.16),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_pin_circle_rounded,
            color: Color(0xFF006E1C),
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBadge() {
    return Positioned(
      left: 24,
      top: 100,
      child: IgnorePointer(
        child: _buildGlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF006E1C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Langsung',
                style: TextStyle(
                  color: Color(0xFF006E1C),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 24,
      top: 100,
      child: Column(
        children: [
          _buildMapControlButton(Icons.add, onPressed: _zoomIn),
          const SizedBox(height: 8),
          _buildMapControlButton(Icons.remove, onPressed: _zoomOut),
          const SizedBox(height: 8),
          _buildMapControlButton(
            Icons.my_location,
            onPressed: _focusPatientLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientPopup(_PatientMapLocation location) {
    final patient = location.patient;
    final address = _stringOrNull(patient.address);
    final risk = _riskLevelPresentation(patient.riskLevel);

    if (address == null) {
      return _buildMessageCard(
        title: patient.fullName,
        message: 'Alamat belum diisi. Titik ditampilkan di pusat Surabaya.',
        icon: Icons.location_searching_rounded,
      );
    }

    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                blurRadius: 40,
                offset: const Offset(0, 20),
                color: Colors.black.withValues(alpha: 0.14),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6EC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person_pin_circle_rounded,
                  color: Color(0xFF006E1C),
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient.fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF191C1D),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'ID: ${patient.patientCode}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildRiskChip(risk),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          location.isApproximate
                              ? Icons.location_searching_rounded
                              : Icons.location_on_outlined,
                          size: 18,
                          color: const Color(0xFF006E1C),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location.isApproximate
                                ? '$address\nTitik ditampilkan di area terdekat.'
                                : address,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 34,
                offset: const Offset(0, 18),
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ],
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF006E1C),
                ),
              ),
              SizedBox(width: 14),
              Text(
                'Memuat lokasi pasien...',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard({
    required String title,
    required String message,
    required IconData icon,
  }) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 34,
                offset: const Offset(0, 18),
                color: Colors.black.withValues(alpha: 0.12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6EC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF006E1C)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskChip(_RiskLevelPresentation risk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: risk.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: risk.foregroundColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            risk.label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: risk.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildMapControlButton(
    IconData icon, {
    required VoidCallback onPressed,
  }) {
    return _buildGlassContainer(
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFF3F4A3C), size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      final matrix = _mapController.value.clone();
      _mapController.value = matrix..scaleByDouble(1.25, 1.25, 1, 1);
    });
  }

  void _zoomOut() {
    setState(() {
      final matrix = _mapController.value.clone();
      _mapController.value = matrix..scaleByDouble(0.8, 0.8, 1, 1);
    });
  }

  void _focusPatientLocation() {
    setState(() {
      _centeredMapKey = null;
    });
  }

  _RiskLevelPresentation _riskLevelPresentation(String riskLevel) {
    return switch (riskLevel.trim().toLowerCase()) {
      'high' => const _RiskLevelPresentation(
        label: 'High Risk',
        backgroundColor: Color(0xFFFEE2E2),
        foregroundColor: Color(0xFFB91C1C),
      ),
      'low' => const _RiskLevelPresentation(
        label: 'Low Risk',
        backgroundColor: Color(0xFFDCFCE7),
        foregroundColor: Color(0xFF15803D),
      ),
      _ => const _RiskLevelPresentation(
        label: 'Medium Risk',
        backgroundColor: Color(0xFFFEF9C3),
        foregroundColor: Color(0xFF854D0E),
      ),
    };
  }

  String? _stringOrNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}

class _PatientMapLocation {
  const _PatientMapLocation({
    required this.patient,
    required this.coordinate,
    this.isApproximate = false,
  });

  final PatientDetail patient;
  final _LatLng coordinate;
  final bool isApproximate;
}

class _LatLng {
  const _LatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class _TileLayout {
  const _TileLayout({
    required this.center,
    required this.startTileX,
    required this.endTileX,
    required this.startTileY,
    required this.endTileY,
    required this.markerOffset,
  });

  final _LatLng center;
  final int startTileX;
  final int endTileX;
  final int startTileY;
  final int endTileY;
  final Offset markerOffset;

  double get size =>
      (_PatientMapPageState._tileRadius * 2 + 1) *
      _PatientMapPageState._tileSize.toDouble();

  factory _TileLayout.forCoordinate(_LatLng coordinate) {
    final tilePoint = _projectToTilePoint(
      coordinate,
      _PatientMapPageState._mapZoom,
    );
    final centerTileX = tilePoint.dx.floor();
    final centerTileY = tilePoint.dy.floor();
    final startTileX = centerTileX - _PatientMapPageState._tileRadius;
    final startTileY = centerTileY - _PatientMapPageState._tileRadius;

    return _TileLayout(
      center: coordinate,
      startTileX: startTileX,
      endTileX: centerTileX + _PatientMapPageState._tileRadius,
      startTileY: startTileY,
      endTileY: centerTileY + _PatientMapPageState._tileRadius,
      markerOffset: Offset(
        (tilePoint.dx - startTileX) * _PatientMapPageState._tileSize,
        (tilePoint.dy - startTileY) * _PatientMapPageState._tileSize,
      ),
    );
  }

  static Offset _projectToTilePoint(_LatLng coordinate, int zoom) {
    final scale = math.pow(2, zoom).toDouble();
    final latitude = coordinate.latitude.clamp(-85.05112878, 85.05112878);
    final longitude = coordinate.longitude.clamp(-180.0, 180.0);
    final latRadians = latitude * math.pi / 180;
    final x = (longitude + 180) / 360 * scale;
    final y =
        (1 -
            math.log(math.tan(latRadians) + 1 / math.cos(latRadians)) /
                math.pi) /
        2 *
        scale;

    return Offset(x, y);
  }
}

class _RiskLevelPresentation {
  const _RiskLevelPresentation({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
}
