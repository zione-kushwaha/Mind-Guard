import 'package:flutter/material.dart';
import '../data/assessment_data.dart';
import '../model/assessment_model.dart';
import 'assessment_result_screen.dart';

class AssessmentQuestionnaireScreen extends StatefulWidget {
  final PTSDCategory category;

  const AssessmentQuestionnaireScreen({Key? key, required this.category}) : super(key: key);

  @override
  _AssessmentQuestionnaireScreenState createState() => _AssessmentQuestionnaireScreenState();
}

class _AssessmentQuestionnaireScreenState extends State<AssessmentQuestionnaireScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentQuestionIndex = 0;
  Map<String, AssessmentResponse> _responses = {};
  bool _isSubmitting = false;

  List<AssessmentQuestion> get questions => assessmentQuestions[widget.category.id] ?? [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Progress Bar
            _buildProgressBar(),
            
            // Question Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                },
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildQuestionCard(questions[index]),
                    ),
                  );
                },
              ),
            ),
            
            // Navigation Buttons
            _buildNavigationButtons(),
          ],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Assessment Questionnaire',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${_currentQuestionIndex + 1}/${questions.length}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [            Text(
              'Question ${_currentQuestionIndex + 1}',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            Text(
              '${((_currentQuestionIndex + 1) / questions.length * 100).toInt()}% Complete',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(AssessmentQuestion question) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF1E3A8A).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              question.question,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                final option = question.options[index];
                final isSelected = _responses[question.id]?.answer == option;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(question, option, index),
                    child:                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF3B82F6).withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF3B82F6)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected 
                                  ? const Color(0xFF3B82F6)
                                  : Colors.transparent,                            border: Border.all(
                              color: isSelected 
                                  ? const Color(0xFF3B82F6)
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child:                            Text(
                              option,
                              style: TextStyle(
                                color: isSelected ? Colors.black87 : Colors.black.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Previous Button
          if (_currentQuestionIndex > 0)
            Expanded(
              child:              OutlinedButton(
                onPressed: _goToPreviousQuestion,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          
          if (_currentQuestionIndex > 0) const SizedBox(width: 16),
          
          // Next/Submit Button
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleNextButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentQuestionIndex == questions.length - 1 ? 'Submit' : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAnswer(AssessmentQuestion question, String answer, int index) {
    setState(() {
      _responses[question.id] = AssessmentResponse(
        questionId: question.id,
        answer: answer,
        score: index, // 0-4 scale
        timestamp: DateTime.now(),
      );
    });
    
    // Auto-advance after selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentQuestionIndex < questions.length - 1) {
        _goToNextQuestion();
      }
    });
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNextButton() {
    final currentQuestion = questions[_currentQuestionIndex];
    
    if (!_responses.containsKey(currentQuestion.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an answer'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }
    
    if (_currentQuestionIndex == questions.length - 1) {
      _submitAssessment();
    } else {
      _goToNextQuestion();
    }
  }

  void _submitAssessment() async {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate processing time
    await Future.delayed(const Duration(milliseconds: 1000));

    // Calculate results
    final result = _calculateResult();
    
    setState(() {
      _isSubmitting = false;
    });

    // Navigate to results
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AssessmentResultScreen(result: result),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  AssessmentResult _calculateResult() {
    int totalScore = 0;
    int maxScore = questions.length * 4; // Maximum score (4 points per question)
    
    for (final response in _responses.values) {
      totalScore += response.score;
    }

    final riskLevel = getRiskLevel(totalScore, maxScore);

    return AssessmentResult(
      categoryId: widget.category.id,
      categoryName: widget.category.name,
      totalScore: totalScore,
      maxScore: maxScore,
      responses: _responses.values.toList(),
      completedAt: DateTime.now(),
      riskLevel: riskLevel,
    );
  }
}
