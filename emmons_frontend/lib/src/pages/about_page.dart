import 'package:flutter/material.dart';
import 'package:candidate_website/src/widgets/common_app_bar.dart';
import 'package:candidate_website/src/widgets/signup_form.dart';
import 'package:candidate_website/src/widgets/donate_section.dart';
import 'package:candidate_website/src/widgets/footer.dart'; // Import the Footer widget

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: 'About Me', // Changed title
        scrollController: _scrollController,
      ),
      body: CustomScrollView( // Changed to CustomScrollView
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 300, // Height of the hero image
              color: Colors.grey[300], // Placeholder color
              child: Center(
                child: Text(
                  'Hero Image: About Me', // Placeholder text
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'About Me', // Changed text here
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // New Biography Content
                          _buildBiographyContent(context),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
                const DonateSection(),
                const SignupFormWidget(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  Widget _buildBiographyContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Born and raised in the heart of Bell County, Curtis Emmons has always felt a deep connection to the people and the values that make Precinct 4 a unique place to live, work, and raise a family. His journey into public service wasn't a sudden decision but a gradual realization that his skills, dedication, and passion for community could make a tangible difference in the lives of his neighbors. From an early age, Curtis was involved in local initiatives, volunteering for community clean-ups, helping at the local food bank, and participating in youth leadership programs. These experiences instilled in him a profound sense of civic duty and a belief in the power of collective action.",
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Emmons_Logo_4_TP.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Emmons_Logo_4_TP.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "After graduating from [Local High School Name], Curtis pursued higher education at [University Name], where he earned a degree in [Relevant Field, e.g., Public Administration, Business Management, Agricultural Science]. His academic pursuits were complemented by a continued commitment to service, including [mention a specific university or early career project or role]. This period was formative, equipping him with a strong analytical mindset, problem-solving abilities, and a deeper understanding of the economic and social dynamics that shape communities like ours. He learned the importance of listening to diverse perspectives, building consensus, and developing practical solutions to complex challenges.",
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Professionally, Curtis has built a successful career as a [Your Profession, e.g., small business owner, project manager, agricultural consultant]. This role has provided him with firsthand experience in [mention relevant skills, e.g., budget management, strategic planning, team leadership, understanding local economic needs]. He understands the challenges faced by local businesses and the importance of creating an environment where they can thrive, generating jobs and contributing to the prosperity of our precinct. His work has always been guided by principles of integrity, hard work, and a commitment to excellence – values he intends to bring to the County Commissioner's office.",
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Emmons_Logo_4_TP.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Emmons_Logo_4_TP.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Beyond his professional life, Curtis is a dedicated family man. He and his spouse, [Spouse's Name, if applicable], have [Number] children, [Children's Names/Ages, if applicable], who attend local schools. This personal connection to the community fuels his desire to ensure Precinct 4 remains a safe, vibrant, and opportunity-rich environment for future generations. He is an active member of [Local Church/Civic Organization, if applicable] and enjoys [Hobbies, e.g., coaching little league, fishing in local rivers, participating in community events].",
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Curtis believes that effective leadership starts with listening. He is committed to being an accessible and responsive representative for all residents of Precinct 4. His vision includes [mention 2-3 key vision points briefly, e.g., improving local infrastructure, enhancing public safety, promoting responsible economic development, ensuring fiscal transparency]. He plans to achieve this by fostering collaboration between community members, local businesses, and county government, ensuring that all voices are heard and that decisions are made with the best interests of the entire precinct in mind. Curtis Emmons is not just running for office; he is stepping up to serve, ready to work tirelessly for the community he calls home.",
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Emmons_Logo_4_TP.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
