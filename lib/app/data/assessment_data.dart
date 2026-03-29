import '../model/assessment_model.dart';

// PTSD Categories
List<PTSDCategory> ptsdCategories = [
  PTSDCategory(
    id: 'abuse',
    name: 'Abuse',
    description: 'Physical, emotional, or sexual abuse experiences',
    emoji: '🛡️',
    icon: 'assets/icons/abuse.png',
    commonSymptoms: ['Trust issues', 'Hypervigilance', 'Emotional numbness', 'Self-blame'],
  ),
  PTSDCategory(
    id: 'assault',
    name: 'Assault',
    description: 'Physical or sexual assault experiences',
    emoji: '⚔️',
    icon: 'assets/icons/assault.png',
    commonSymptoms: ['Anxiety in crowds', 'Avoidance behaviors', 'Panic attacks', 'Sleep disturbances'],
  ),
  PTSDCategory(
    id: 'war',
    name: 'War/Combat',
    description: 'Military combat or war-related trauma',
    emoji: '🎖️',
    icon: 'assets/icons/war.png',
    commonSymptoms: ['Survivor guilt', 'Hypervigilance', 'Flashbacks', 'Emotional detachment'],
  ),
  PTSDCategory(
    id: 'accident',
    name: 'Accident',
    description: 'Motor vehicle or other traumatic accidents',
    emoji: '🚗',
    icon: 'assets/icons/accident.png',
    commonSymptoms: ['Fear of driving', 'Anxiety about safety', 'Intrusive thoughts', 'Avoidance'],
  ),
  PTSDCategory(
    id: 'other',
    name: 'Other',
    description: 'Other traumatic experiences',
    emoji: '💭',
    icon: 'assets/icons/other.png',
    commonSymptoms: ['Varied symptoms', 'Emotional distress', 'Behavioral changes', 'Sleep issues'],
  ),
];

// Assessment Questions for each category
Map<String, List<AssessmentQuestion>> assessmentQuestions = {
  'abuse': [
    AssessmentQuestion(
      id: 'abuse_1',
      question: 'How often do you have unwanted memories of the abuse?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'abuse_2',
      question: 'Do you avoid places or situations that remind you of the abuse?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'abuse_3',
      question: 'How difficult is it for you to trust others?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'abuse',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'abuse_4',
      question: 'Do you feel emotionally numb or detached from others?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'abuse_5',
      question: 'How often do you blame yourself for what happened?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'abuse_6',
      question: 'Do you have trouble sleeping or nightmares?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'abuse_7',
      question: 'How easily are you startled or frightened?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'abuse',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'abuse_8',
      question: 'Do you feel constantly on guard or watchful?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'abuse_9',
      question: 'How often do you feel angry or irritable?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'abuse_10',
      question: 'Do you have difficulty concentrating?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'abuse_11',
      question: 'How often do you feel guilty or ashamed?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'abuse_12',
      question: 'Do you avoid talking about the traumatic experience?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'abuse',
      severity: 3,
    ),
  ],
  'assault': [
    AssessmentQuestion(
      id: 'assault_1',
      question: 'How often do you relive the assault through flashbacks?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 5,
    ),
    AssessmentQuestion(
      id: 'assault_2',
      question: 'Do you avoid crowded places or situations?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'assault_3',
      question: 'How often do you experience panic attacks?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'assault_4',
      question: 'Do you feel unsafe even in familiar places?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'assault_5',
      question: 'How difficult is it to be physically close to others?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'assault',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'assault_6',
      question: 'Do you have intrusive thoughts about the assault?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'assault_7',
      question: 'How often do you check your surroundings for danger?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'assault_8',
      question: 'Do you feel like the assault was your fault?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'assault_9',
      question: 'How often do you feel disconnected from your body?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'assault_10',
      question: 'Do you avoid activities you used to enjoy?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'assault_11',
      question: 'How often do you feel hopeless about the future?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'assault_12',
      question: 'Do you have trouble remembering details of the assault?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'assault',
      severity: 2,
    ),
  ],
  'war': [
    AssessmentQuestion(
      id: 'war_1',
      question: 'How often do you have vivid memories of combat situations?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'war_2',
      question: 'Do you feel guilty about surviving when others didn\'t?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 5,
    ),
    AssessmentQuestion(
      id: 'war_3',
      question: 'How easily are you startled by loud noises?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'war',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'war_4',
      question: 'Do you avoid war movies or news about conflicts?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'war_5',
      question: 'How often do you feel emotionally detached from loved ones?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'war_6',
      question: 'Do you have difficulty enjoying activities you used to love?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'war_7',
      question: 'How often do you scan your environment for threats?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'war_8',
      question: 'Do you have trouble sleeping due to war-related dreams?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'war_9',
      question: 'How often do you feel angry without clear reason?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'war_10',
      question: 'Do you avoid talking about your military service?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'war_11',
      question: 'How difficult is it to concentrate on daily tasks?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'war',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'war_12',
      question: 'Do you feel like civilians don\'t understand your experiences?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'war',
      severity: 3,
    ),
  ],
  'accident': [
    AssessmentQuestion(
      id: 'accident_1',
      question: 'How often do you relive the accident in your mind?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'accident_2',
      question: 'Do you avoid driving or being a passenger in vehicles?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'accident_3',
      question: 'How anxious do you feel about your safety in general?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'accident',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'accident_4',
      question: 'Do you have intrusive thoughts about the accident?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'accident_5',
      question: 'How often do you feel like the accident was your fault?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'accident_6',
      question: 'Do you avoid places similar to where the accident occurred?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'accident_7',
      question: 'How easily are you startled by sudden movements or sounds?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'accident',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'accident_8',
      question: 'Do you have nightmares about the accident?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'accident_9',
      question: 'How often do you feel disconnected from others?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'accident_10',
      question: 'Do you have difficulty concentrating since the accident?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'accident_11',
      question: 'How often do you feel irritable or angry?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'accident_12',
      question: 'Do you avoid discussing the accident with others?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'accident',
      severity: 3,
    ),
  ],
  'other': [
    AssessmentQuestion(
      id: 'other_1',
      question: 'How often do you have unwanted memories of the traumatic event?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'other_2',
      question: 'Do you avoid reminders of the traumatic experience?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'other_3',
      question: 'How often do you feel emotionally numb?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'other_4',
      question: 'Do you have trouble sleeping or nightmares?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'other_5',
      question: 'How easily are you startled or frightened?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Very', 'Extremely'],
      category: 'other',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'other_6',
      question: 'Do you feel constantly alert or on guard?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'other_7',
      question: 'How often do you feel guilty or blame yourself?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'other_8',
      question: 'Do you have difficulty concentrating?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'other_9',
      question: 'How often do you feel irritable or have angry outbursts?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 2,
    ),
    AssessmentQuestion(
      id: 'other_10',
      question: 'Do you avoid activities you used to enjoy?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 3,
    ),
    AssessmentQuestion(
      id: 'other_11',
      question: 'How often do you feel hopeless about the future?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 4,
    ),
    AssessmentQuestion(
      id: 'other_12',
      question: 'Do you have trouble remembering details of the traumatic event?',
      options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      category: 'other',
      severity: 2,
    ),
  ],
};

// Helper function to get risk level based on score
String getRiskLevel(int score, int maxScore) {
  double percentage = (score / maxScore) * 100;
  
  if (percentage >= 80) return 'Severe';
  if (percentage >= 60) return 'High';
  if (percentage >= 40) return 'Moderate';
  return 'Low';
}

// Helper function to get recommendations based on risk level
List<String> getRecommendations(String riskLevel) {
  switch (riskLevel) {
    case 'Severe':
      return [
        'Consider seeking immediate professional help',
        'Contact a mental health crisis hotline',
        'Reach out to trusted friends or family',
        'Use emergency support features in the app'
      ];
    case 'High':
      return [
        'Strongly consider professional therapy',
        'Practice daily grounding exercises',
        'Build a support network',
        'Use app features regularly for coping'
      ];
    case 'Moderate':
      return [
        'Consider talking to a counselor',
        'Practice stress management techniques',
        'Stay connected with supportive people',
        'Use app resources for self-care'
      ];
    case 'Low':
      return [
        'Continue healthy coping strategies',
        'Stay aware of your mental health',
        'Use app features for maintenance',
        'Consider professional help if symptoms worsen'
      ];
    default:
      return [];
  }
}
