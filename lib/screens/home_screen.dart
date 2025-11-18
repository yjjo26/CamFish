import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../models/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  final PanelController _panelController = PanelController();

  // 현재 위치 (서울 기본값)
  LatLng _currentPosition = const LatLng(37.5665, 126.9780);

  // 필터 상태
  String _filter = 'all'; // 'all', 'camping', 'fishing'

  // 검색어
  String _searchQuery = '';

  // 샘플 위치 데이터
  final List<Location> _locations = [
    Location(
      id: '1',
      name: '한강 캠핑장',
      coordinates: Coordinates(lat: 37.5326, lng: 127.0246),
      distance: 5.2,
      camping: CampingInfo(
        available: true,
        facilities: ['화장실', '주차장', '샤워실'],
        price: 15000,
      ),
      fishing: FishingInfo(available: false),
      weather: WeatherInfo(
        temperature: 22,
        windSpeed: 2.5,
        precipitation: 0,
        condition: '맑음',
        icon: '☀️',
      ),
      thumbnail: '',
    ),
    Location(
      id: '2',
      name: '양재천 낚시터',
      coordinates: Coordinates(lat: 37.4713, lng: 127.0456),
      distance: 3.8,
      camping: CampingInfo(available: false, facilities: []),
      fishing: FishingInfo(
        available: true,
        fishTypes: [
          FishType(
            name: '붕어',
            season: '연중',
            size: '20cm',
            difficulty: 'easy',
          ),
        ],
        bestSeason: '4-10월',
        regulations: ['낚시면허 필요'],
      ),
      weather: WeatherInfo(
        temperature: 21,
        windSpeed: 1.8,
        precipitation: 0,
        condition: '맑음',
        icon: '☀️',
      ),
      thumbnail: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 전체 화면 지도
          _buildMap(),

          // 상단 네비게이션 바
          _buildTopNavBar(),

          // 슬라이딩 패널 (검색 및 목록)
          _buildSlidingPanel(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 13,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: _getMarkers(),
    );
  }

  Set<Marker> _getMarkers() {
    return _locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(
          location.coordinates.lat,
          location.coordinates.lng,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          location.camping.available
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueBlue,
        ),
        onTap: () {
          // 마커 클릭 시 패널 열기
          _panelController.open();
        },
      );
    }).toSet();
  }

  Widget _buildTopNavBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 메뉴 버튼
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
              ),

              // 필터 버튼
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B70FC), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'P',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _filter == 'camping'
                          ? '캠핑장'
                          : _filter == 'fishing'
                              ? '낚시터'
                              : '전체',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

  Widget _buildSlidingPanel() {
    return SlidingUpPanel(
      controller: _panelController,
      minHeight: 180,
      maxHeight: MediaQuery.of(context).size.height * 0.85,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(40),
      ),
      panel: _buildPanelContent(),
      body: const SizedBox(),
    );
  }

  Widget _buildPanelContent() {
    return Column(
      children: [
        // 패널 핸들
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 20),

        // 카테고리 버튼들
        _buildCategoryButtons(),

        const SizedBox(height: 16),

        // 검색 바
        _buildSearchBar(),

        const SizedBox(height: 20),

        // 위치 목록
        Expanded(
          child: _buildLocationList(),
        ),
      ],
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildCategoryButton(
            '🏕️',
            '캠핑',
            'camping',
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
          ),
          const SizedBox(width: 12),
          _buildCategoryButton(
            '🎣',
            '낚시',
            'fishing',
            const Color(0xFF3B82F6),
            const Color(0xFFDBEAFE),
          ),
          const SizedBox(width: 12),
          _buildCategoryButton(
            '🛍️',
            '쇼핑',
            'all',
            const Color(0xFF8B5CF6),
            const Color(0xFFEDE9FE),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    String emoji,
    String label,
    String filterValue,
    Color activeColor,
    Color lightColor,
  ) {
    final bool isActive = _filter == filterValue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filter = filterValue;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isActive ? lightColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? activeColor : Colors.grey[200]!,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : lightColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? activeColor : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '주소로 검색...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF5B70FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationList() {
    final filteredLocations = _locations.where((location) {
      if (_filter == 'camping') return location.camping.available;
      if (_filter == 'fishing') return location.fishing.available;
      return true;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        return _buildLocationCard(location);
      },
    );
  }

  Widget _buildLocationCard(Location location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 아이콘
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                location.camping.available ? '🏕️' : '🎣',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${location.coordinates.lat.toStringAsFixed(4)}, ${location.coordinates.lng.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // 거리
          Text(
            '${location.distance} km',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
