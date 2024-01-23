class OnboardingContent {
  String? image;
  String? title;
  String? stepperTitle;

  OnboardingContent({this.image, this.title, this.stepperTitle});
}

List<OnboardingContent> contentsBoarding = [
  OnboardingContent(
      image: "assets/images/3.jpg",
      title: "Safety of your Home",
      stepperTitle: "Safety"),
  OnboardingContent(
      image: "assets/images/1.jpg",
      title: "Peace of mind",
      stepperTitle: "Peace"),
  OnboardingContent(
      image: "assets/images/2.jpg",
      title: "One Community",
      stepperTitle: "Community"),
];
