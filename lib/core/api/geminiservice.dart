import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "AIzaSyBC74e4S5iWC6oC1NRZ9s9iSvSrx33638g";

  Future<String?> getResponse(String requestTemp) async {
    final GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final content = [Content.text("this is the data of a patient we have it contain values of  sugarPercentage ,time , date and healthConditionScore  all you should do is give me a brief about its health condition lately  in 100 words : $requestTemp")];
    final response = await model.generateContent(content);
    print(response.text);
    return response.text;
  }
}
