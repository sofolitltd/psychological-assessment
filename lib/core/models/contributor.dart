class Contributor {
  final String name;
  final String post;
  final String institution;
  final String avatarUrl;

  const Contributor({
    required this.name,
    this.post = 'Student',
    this.institution = 'University of Chittagong',
    this.avatarUrl = '',
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

const contributors = [
  Contributor(name: 'Marium Mojumder Samia',post: 'B.Sc in Psychology (Cu)', institution: 'MS in Psychology (CU)'),
  Contributor(name: 'Lubaba Azad', post: 'B.Sc in Psychology (Cu)', institution: 'MS in Clinical Psychology (DU)'),
  Contributor(name: 'Afzal Hossain Hridoy', post: 'Behavior Therapist, Tender Twig', institution: 'B.Sc, MS, in Psychology(CU)'),
  Contributor(name: 'Azizul Hakim Sojol', post: 'Counselor, Wellbeing Clinic', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Bibi Hazear', post: 'Counselor', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Upoma Eti', post: 'Lieutenant', institution: 'Bangladesh Army'),
  Contributor(name: 'BM Emon', post: 'Counselor', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Nabiul Hasan', post: 'Psychologist, Life Spring', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Israt Jahan Moon', post: 'Counselor', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Mahir Bin Sekander', post: 'Counselor, Nany Anchor College, CTG', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Imti Ruffian', post: 'Psychologist, Life Spring', institution: 'B.Sc, MS in Psychology (CU)'),
  Contributor(name: 'Dr. Md Nurul Islam', post: 'Professor, Dept. of Psychology', institution: 'University of Chittagong'),
  Contributor(name: 'Dr. Rumana Aktar', post: 'Professor, Dept. of Psychology', institution: 'University of Chittagong'),
  Contributor(name: 'Lailun Nahar Irany', post: 'Associate Professor, Dept. of Psychology', institution: 'University of Chittagong'),
  Contributor(name: 'Rohmotul Islam Hridoy', post: 'Assistant Professor, Dept. of Psychology', institution: 'University of Chittagong'),
];
