import '../model/image_data.dart';

List<PTSDFeature> ptsdFeatures = [
  // Emergency Support
  PTSDFeature(
    id: 'emergency_support',
    name: 'EMERGENCY SUPPORT',
    urlImage: 'assets/first/ar.png',
    description: 'Quick access to emergency contacts and crisis support',
    emoji: '🆘',
    category: 'Emergency',
    benefits: ['Immediate Help', 'Crisis Support', 'Safety'],
    route: '/emergency',
    isEmergency: true,
  ),
  
  // Grounding Exercises
  PTSDFeature(
    id: 'grounding_exercises',
    name: 'GROUNDING EXERCISES',
    urlImage: 'assets/first/ar.png',
    description: 'Interactive 5-4-3-2-1 technique and mindfulness exercises',
    emoji: '🧘',
    category: 'Mindfulness',
    benefits: ['Anxiety Relief', 'Present Focus', 'Calm Mind'],
    route: '/grounding',
  ),
  
  // Breathing Exercises
  PTSDFeature(
    id: 'breathing_exercises',
    name: 'BREATHING GUIDE',
    urlImage: 'assets/first/ar.png',
    description: 'Animated breathing exercises to reduce anxiety and stress',
    emoji: '🫁',
    category: 'Relaxation',
    benefits: ['Stress Relief', 'Relaxation', 'Focus'],
    route: '/breathing',
  ),
  
  // Soothing Audio
  PTSDFeature(
    id: 'soothing_audio',
    name: 'CALM SOUNDS',
    urlImage: 'assets/first/ar.png',
    description: 'Nature sounds, binaural beats, and sound mixing studio',
    emoji: '🎵',
    category: 'Audio',
    benefits: ['Relaxation', 'Sleep Aid', 'Focus'],
    route: '/audio',
  ),
  
  // Yoga & Movement
  PTSDFeature(
    id: 'yoga_movement',
    name: 'YOGA & MOVEMENT',
    urlImage: 'assets/first/ar.png',
    description: 'Gentle yoga poses and movement therapy for trauma recovery',
    emoji: '🧘‍♀️',
    category: 'Movement',
    benefits: ['Body Awareness', 'Flexibility', 'Inner Peace'],
    route: '/yoga',
  ),
  
  // Neural Beats
  PTSDFeature(
    id: 'neural_beats',
    name: 'NEURAL BEATS',
    urlImage: 'assets/first/ar.png',
    description: 'Binaural beats for brain synchronization and relaxation',
    emoji: '🧠',
    category: 'Audio',
    benefits: ['Focus', 'Relaxation', 'Brain Health'],
    route: '/neural-beats',
  ),
  
  // Journaling
  PTSDFeature(
    id: 'journaling',
    name: 'SECURE JOURNAL',
    urlImage: 'assets/first/ar.png',
    description: 'Encrypted journaling with mood tracking and insights',
    emoji: '📔',
    category: 'Reflection',
    benefits: ['Self-Reflection', 'Progress Tracking', 'Emotional Release'],
    route: '/journal',
    requiresAuth: true,
  ),
  
  // Mind Games
  PTSDFeature(
    id: 'mind_games',
    name: 'MIND GAMES',
    urlImage: 'assets/first/ar.png',
    description: 'Cognitive games to improve focus and mental clarity',
    emoji: '🧩',
    category: 'Cognitive',
    benefits: ['Focus', 'Memory', 'Mental Agility'],
    route: '/games',
  ),
  
  // Trauma-Informed Games
  PTSDFeature(
    id: 'trauma_games',
    name: 'HEALING GAMES',
    urlImage: 'assets/first/ar.png',
    description: 'Specially designed games for trauma recovery and resilience',
    emoji: '🎮',
    category: 'Therapeutic',
    benefits: ['Healing', 'Resilience', 'Empowerment'],
    route: '/trauma-games',
  ),
  
  // Meditation & Stories
  PTSDFeature(
    id: 'meditation_stories',
    name: 'GUIDED MEDITATION',
    urlImage: 'assets/first/ar.png',
    description: 'PTSD-focused meditation and calming audio stories',
    emoji: '🎧',
    category: 'Mindfulness',
    benefits: ['Inner Peace', 'Stress Relief', 'Mindfulness'],
    route: '/meditation',
  ),
  
  // Community Support
  PTSDFeature(
    id: 'community',
    name: 'PEER SUPPORT',
    urlImage: 'assets/first/ar.png',
    description: 'Connect with others in a safe, moderated environment',
    emoji: '👥',
    category: 'Community',
    benefits: ['Connection', 'Support', 'Understanding'],
    route: '/community',
  ),
  
  // Professional Help
  PTSDFeature(
    id: 'professional_help',
    name: 'FIND THERAPIST',
    urlImage: 'assets/first/therapist.png',
    description: 'Directory of PTSD specialists and mental health professionals',
    emoji: '👨‍⚕️',
    category: 'Professional',
    benefits: ['Expert Help', 'Specialized Care', 'Recovery'],
    route: '/therapist',
  ),

  // Premium Camera Feature
  PTSDFeature(
    id: 'premium_camera',
    name: 'MOOD CAMERA',
    urlImage: 'assets/first/ar.png',
    description: 'AI-powered mood analysis through facial recognition',
    emoji: '📸',
    category: 'Premium',
    benefits: ['Mood Tracking', 'AI Analysis', 'Progress Insights'],
    route: '/camera',
    isPremium: true,
    requiresAuth: true,
  ),
];

// Legacy support for existing code
List<imageData> locations = [
  imageData(
    name: 'Do Yoga',
    urlImage: 'assets/first/yoga.png',
    description: 'Gentle yoga poses and movement therapy for trauma recovery',
    emoji: '🆘',
    recommendedAge: 18,
    skills: ['Body Awareness', 'Flexibility', 'Inner Peace'],
  ),
  imageData(
    name: 'Augmented Reality',
    urlImage: 'assets/first/ar.png',
    description: 'Augmented reality experiences for grounding and mindfulness',
    emoji: '🧘',
    recommendedAge: 16,
    skills: ['Mindfulness', 'Anxiety Management', 'Present Focus'],
  ),
  //  Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => WordReadingCameraScreen(),
  //                             ),
  //                           );
  imageData(
    name: 'Today\'s Mood',
    urlImage: 'assets/first/today.png',
    description: 'Reflect on your current mood and feelings',
    emoji: '🫁',
    recommendedAge: 12,
    skills: ['Relaxation', 'Stress Relief', 'Self-Regulation'],
  ),
    imageData(
    name: 'Dot Game',
    urlImage: 'assets/first/game.png',
    description: 'See the Dots game for congenitive focus and mental clarity',
    emoji: '🧠',
    recommendedAge: 12,
    skills: ['Relaxation', 'Stress Relief', 'Self-Regulation'],
  ),
];
