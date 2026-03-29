import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  WebViewController? _controller;
  bool isLoading = true;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeWebViewWithPermissions();
  }

  Future<void> _initializeWebViewWithPermissions() async {
    // Request camera and microphone permissions
    await _requestPermissions();
    
    // Initialize WebView after permissions
    _initializeWebView();
  }

  Future<void> _requestPermissions() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      
      // Request microphone permission (often needed for web apps)
      final microphoneStatus = await Permission.microphone.request();
      
      print('Camera permission: $cameraStatus');
      print('Microphone permission: $microphoneStatus');
      
      if (cameraStatus.isDenied || microphoneStatus.isDenied) {
        // Show dialog to user about permissions
        if (mounted) {
          _showPermissionDialog();
        }
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.green),
              SizedBox(width: 8),
              Text('Camera Access Required'),
            ],
          ),
          content: const Text(
            'This yoga session requires camera access to track your movements and provide feedback. '
            'Please enable camera and microphone permissions in your device settings for the best experience.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Continue Without Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _initializeWebView() {
    try {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller =
          WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
              if (progress > 15) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
              });
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
              debugPrint('Page finished loading: $url');
              
              // Inject camera permission script after page loads
              _injectCameraScript();
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('''
        Page resource error:
        code: ${error.errorCode}
        description: ${error.description}
        errorType: ${error.errorType}
        isForMainFrame: ${error.isForMainFrame}
            ''');
              
              // Handle WebView crashes more gracefully
              if (error.isForMainFrame == true) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('blocking navigation to ${request.url}');
                return NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
            onUrlChange: (UrlChange change) {
              debugPrint('url change to ${change.url}');
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse(
            'https://pleasing-guppy-hardy.ngrok-free.app/api/yoga/'));

      _controller = controller;
      
      setState(() {
        isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing WebView: $e');
      setState(() {
        isLoading = false;
        isInitialized = false;
      });
    }
  }

  Future<void> _checkPermissionsAndShow() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Camera: ${cameraStatus.toString()}'),
              Text('Microphone: ${microphoneStatus.toString()}'),
              const SizedBox(height: 16),
              const Text(
                'If permissions are denied, please enable them in device settings for the camera to work in the web interface.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            if (cameraStatus.isDenied || microphoneStatus.isDenied)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
          ],
        ),
      );
    }
  }

  Future<void> _injectCameraScript() async {
    if (_controller == null) return;
    
    // Inject JavaScript to help with camera access
    const script = '''
      (function() {
        // Request camera access from web side
        if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
          console.log('MediaDevices API available');
          
          // Function to request camera access
          window.requestCameraAccess = function() {
            return navigator.mediaDevices.getUserMedia({ video: true, audio: true })
              .then(function(stream) {
                console.log('Camera access granted');
                // Stop the stream immediately, we just wanted to trigger permission
                stream.getTracks().forEach(track => track.stop());
                return true;
              })
              .catch(function(error) {
                console.error('Camera access denied:', error);
                return false;
              });
          };
          
          // Auto-request on page load
          setTimeout(function() {
            window.requestCameraAccess();
          }, 2000);
        } else {
          console.log('MediaDevices API not available');
        }
      })();
    ''';
    
    try {
      await _controller!.runJavaScript(script);
    } catch (e) {
      print('Error injecting camera script: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller != null && await _controller!.canGoBack()) {
          _controller!.goBack();
          return false; // Prevent the app from closing
        } else {
          return true; // Allow the app to close
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Yoga Session'),
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller?.reload();
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                _checkPermissionsAndShow();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (isInitialized && _controller != null)
                WebViewWidget(controller: _controller!)
              else if (!isLoading)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.web,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'WebView not initialized',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            isInitialized = false;
                          });
                          _initializeWebViewWithPermissions();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else
                const Center(
                  child: Text('Initializing WebView...'),
                ),
              if (isLoading)
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading yoga session...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Please allow camera access when prompted',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}