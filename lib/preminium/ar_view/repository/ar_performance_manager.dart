import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ARPerformanceManager {
  static final ARPerformanceManager _instance = ARPerformanceManager._internal();
  factory ARPerformanceManager() => _instance;
  ARPerformanceManager._internal();

  // Performance tracking
  final Map<String, Stopwatch> _timers = {};
  final Map<String, int> _counters = {};
  bool _isOptimizationEnabled = true;

  // Model caching
  final Map<String, dynamic> _modelCache = {};
  final int _maxCacheSize = 10;

  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  void stopTimer(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      if (kDebugMode) {
        print('Performance: $name took ${timer.elapsedMilliseconds}ms');
      }
    }
  }

  void incrementCounter(String name) {
    _counters[name] = (_counters[name] ?? 0) + 1;
  }

  void resetCounters() {
    _counters.clear();
  }

  Map<String, int> getCounters() => Map.from(_counters);

  // Model optimization
  Future<void> preloadModel(String url) async {
    if (_modelCache.containsKey(url) || _modelCache.length >= _maxCacheSize) {
      return;
    }

    try {
      startTimer('model_preload_$url');
      // In a real implementation, you would preload the model here
      // For now, we just mark it as cached
      _modelCache[url] = {'preloaded': true, 'timestamp': DateTime.now()};
      stopTimer('model_preload_$url');
    } catch (e) {
      if (kDebugMode) {
        print('Failed to preload model $url: $e');
      }
    }
  }

  bool isModelCached(String url) {
    return _modelCache.containsKey(url);
  }

  void clearCache() {
    _modelCache.clear();
  }

  // Memory optimization
  Future<void> optimizeMemory() async {
    if (!_isOptimizationEnabled) return;

    try {
      // Trigger garbage collection
      await _triggerGC();
      
      // Clear old cached models (older than 5 minutes)
      final now = DateTime.now();
      _modelCache.removeWhere((key, value) {
        final timestamp = value['timestamp'] as DateTime?;
        return timestamp != null && 
               now.difference(timestamp).inMinutes > 5;
      });

      if (kDebugMode) {
        print('Memory optimization completed. Cache size: ${_modelCache.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Memory optimization failed: $e');
      }
    }
  }

  Future<void> _triggerGC() async {
    // Force garbage collection on different platforms
    if (defaultTargetPlatform == TargetPlatform.android) {
      await SystemChannels.platform.invokeMethod('System.gc');
    }
    // For iOS and other platforms, we rely on Dart's automatic GC
  }

  // AR session optimization
  Map<String, dynamic> getOptimizedARConfig() {
    return {
      'showFeaturePoints': false, // Disabled for better performance
      'showPlanes': true,
      'handleTaps': true,
      'handlePans': true,
      'handleRotation': true,
      'showAnimatedGuide': _isOptimizationEnabled,
      'enableDepthOcclusion': false, // Can be resource intensive
      'enableLightEstimation': false, // Saves battery
    };
  }

  // Quality settings based on device performance
  double getOptimalModelScale() {
    // In a real implementation, you would check device capabilities
    // For now, return a conservative scale
    return 0.15;
  }

  int getOptimalTextureQuality() {
    // Return texture quality based on device performance
    // 0 = low, 1 = medium, 2 = high
    return 1; // Medium quality as default
  }

  // Battery optimization
  void enablePowerSaving() {
    _isOptimizationEnabled = true;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, 
        overlays: [SystemUiOverlay.top]);
  }

  void disablePowerSaving() {
    _isOptimizationEnabled = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, 
        overlays: SystemUiOverlay.values);
  }

  // Performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'timers': _timers.map((key, value) => 
          MapEntry(key, value.elapsedMilliseconds)),
      'counters': _counters,
      'cache_size': _modelCache.length,
      'optimization_enabled': _isOptimizationEnabled,
    };
  }

  void printPerformanceReport() {
    if (!kDebugMode) return;

    print('\n=== AR Performance Report ===');
    print('Optimization Enabled: $_isOptimizationEnabled');
    print('Cached Models: ${_modelCache.length}');
    
    print('\nTimers:');
    _timers.forEach((name, timer) {
      print('  $name: ${timer.elapsedMilliseconds}ms');
    });
    
    print('\nCounters:');
    _counters.forEach((name, count) {
      print('  $name: $count');
    });
    print('========================\n');
  }
}

// Extension methods for easier usage
extension ARPerformanceExtension on ARPerformanceManager {
  Future<T> measureTime<T>(String name, Future<T> Function() operation) async {
    startTimer(name);
    try {
      final result = await operation();
      return result;
    } finally {
      stopTimer(name);
    }
  }
}
