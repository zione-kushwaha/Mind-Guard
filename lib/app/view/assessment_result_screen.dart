import 'package:flutter/material.dart';
import '../data/assessment_data.dart';
import '../model/assessment_model.dart';

class AssessmentResultScreen extends StatefulWidget {
  final AssessmentResult result;

  const AssessmentResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  _AssessmentResultScreenState createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.result.percentage / 100).animate(
      CurvedAnimation(parent: _progressAnimationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
    
    // Start progress animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _progressAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Results Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Score Circle
                        _buildScoreCircle(),
                        
                        const SizedBox(height: 32),
                        
                        // Risk Level Card
                        _buildRiskLevelCard(),
                        
                        const SizedBox(height: 24),
                        
                        // Recommendations
                        _buildRecommendations(),
                        
                        const SizedBox(height: 24),
                        
                        // Assessment Summary
                        _buildAssessmentSummary(),
                      ],
                    ),
                  ),
                ),
                
                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Assessment Results',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showShareDialog(),
                icon: const Icon(
                  Icons.share,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCircle() {
    return Container(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Background Circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              
              // Progress Circle
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 8,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(_getRiskColor()),
                ),
              ),
              
              // Content
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.result.percentage.toInt()}%',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.result.riskLevel,
                      style: TextStyle(
                        color: _getRiskColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.result.categoryName,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRiskLevelCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getRiskColor().withOpacity(0.1),
            _getRiskColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getRiskColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _getRiskIcon(),
                color: _getRiskColor(),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '${widget.result.riskLevel} Risk Level',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getRiskDescription(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final recommendations = getRecommendations(widget.result.riskLevel);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF60A5FA),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Recommendations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map((recommendation) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF60A5FA),
                  ),
                ),
                Expanded(
                  child: Text(
                    recommendation,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAssessmentSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.assessment,
                color: Color(0xFF60A5FA),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Assessment Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Questions Answered', '${widget.result.responses.length}'),
          _buildSummaryRow('Total Score', '${widget.result.totalScore}/${widget.result.maxScore}'),
          _buildSummaryRow('Category', widget.result.categoryName),
          _buildSummaryRow('Completed', _formatDate(widget.result.completedAt)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Return to Home Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _returnToHome(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Return to Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Retake Assessment Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _retakeAssessment(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF374151)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Retake Assessment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor() {
    switch (widget.result.riskLevel) {
      case 'Severe':
        return const Color(0xFFDC2626);
      case 'High':
        return const Color(0xFFEA580C);
      case 'Moderate':
        return const Color(0xFFCA8A04);
      case 'Low':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getRiskIcon() {
    switch (widget.result.riskLevel) {
      case 'Severe':
        return Icons.warning;
      case 'High':
        return Icons.error_outline;
      case 'Moderate':
        return Icons.info_outline;
      case 'Low':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  String _getRiskDescription() {
    switch (widget.result.riskLevel) {
      case 'Severe':
        return 'Your responses indicate severe trauma symptoms. It\'s important to seek professional help immediately.';
      case 'High':
        return 'Your responses suggest significant trauma symptoms. Consider speaking with a mental health professional.';
      case 'Moderate':
        return 'Your responses indicate moderate trauma symptoms. Professional support may be beneficial.';
      case 'Low':
        return 'Your responses suggest minimal trauma symptoms. Continue monitoring your wellbeing.';
      default:
        return 'Assessment completed successfully.';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          'Share Results',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Share your assessment results with a healthcare provider or trusted person?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement share functionality
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _returnToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _retakeAssessment() {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
