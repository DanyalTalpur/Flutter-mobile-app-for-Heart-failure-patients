const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('اردو', 'ur_PK'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}
