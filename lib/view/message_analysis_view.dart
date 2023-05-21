import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/model/chat_model.dart';
import 'package:the_voice/model/build_model.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/util/constant.dart';

class MessageAnalysisView extends StatefulWidget {
  final String number;
  final int threadId;

  const MessageAnalysisView({
    super.key,
    required this.number,
    required this.threadId,
  });

  @override
  State<MessageAnalysisView> createState() => _MessageAnalysisViewState();
}

class _MessageAnalysisViewState extends State<MessageAnalysisView> {
  late List<MessageModel> messages;
  late List<dynamic> probabilities;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> future() async {
    try {
      messages = await MessageController.fetchMessages(widget.threadId);
      List<dynamic> requests = [];

      for (int i = 0; i < messages.length; i++) {
        if (messages[i].sender == Sender.user) {
          continue;
        }
        requests.add(
          {
            'id': messages[i].smsMessage.id!,
            'content': messages[i].smsMessage.body!
          },
        );
      }

      probabilities = await MessageController.analyze(requests);

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Consumer<SettingModel>(
      builder: (_, value, __) => FutureBuilder(
        future: future(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (probabilities.isNotEmpty &&
                probabilities[0]['probability'] >= 0.0) {
              return Scaffold(
                backgroundColor: _getBackgroundColor(
                  cs,
                  probabilities[0]['probability'],
                ),
                appBar: _buildAppBar(
                  widget.number,
                  cs,
                  probabilities[0]['probability'],
                ),
                body: _buildBody(
                  value,
                  cs,
                  tt,
                  probabilities[0]['probability'],
                ),
              );
            } else {
              return _buildError(
                  value, cs, tt, probabilities[0]['probability']);
            }
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    String title,
    ColorScheme colorScheme,
    double probability,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        title,
        style: TextStyle(
          color: _getOnSurfaceColor(colorScheme, probability),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        color: _getOnSurfaceColor(colorScheme, probability),
      ),
      systemOverlayStyle: _getSystemUiOverlayStyle(
        Theme.of(context).brightness,
        probability,
      ),
    );
  }

  Widget _buildBody(
    SettingModel settingModel,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double probability,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 64,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTitle(probability, colorScheme, textTheme),
            const SizedBox(height: 8),
            _getProbability(probability, colorScheme, textTheme),
            const SizedBox(height: 32),
            const Divider(endIndent: 128),
            const SizedBox(height: 32),
            _getBody(probability, colorScheme, textTheme),
            const SizedBox(height: 8),
            _getLabel(
              ['2023', 'Google', 'Solution', 'Challenge'],
              probability,
              colorScheme,
              textTheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    SettingModel settingModel,
    ColorScheme colorScheme,
    TextTheme textTheme,
    double probability,
  ) {
    return Scaffold(
      appBar: BuildAppBar(pushed: true, title: widget.number),
      body: Center(
        child: Builder(
          builder: (_) {
            if (probability == ERROR_NOFILE) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ERROR',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'NO FILE',
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  )
                ],
              );
            } else if (probability == ERROR_SERVER) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ERROR',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'SERVER',
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  )
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ERROR',
                    style: textTheme.headlineLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    (-probability.toInt()).toString(),
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      appBar: BuildAppBar(pushed: true, title: widget.number),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme, double probability) {
    TonalPalette toTonalPallete(Color color) {
      final hct = Hct.fromInt(color.value);
      return TonalPalette.of(hct.hue, hct.chroma);
    }

    if (probability > THRESHOLD4) {
      return colorScheme.tertiary;
    } else if (probability > THRESHOLD3) {
      return Color(toTonalPallete(colorScheme.tertiary).get(60));
    } else if (probability > THRESHOLD2) {
      return colorScheme.surfaceVariant;
    } else if (probability > THRESHOLD1) {
      return Color(toTonalPallete(colorScheme.primary).get(60));
    } else {
      return colorScheme.primary;
    }
  }

  Color _getOnSurfaceColor(ColorScheme colorScheme, double probability) {
    if (probability > THRESHOLD3) {
      return colorScheme.onTertiary;
    } else if (probability > THRESHOLD2) {
      return colorScheme.onSurfaceVariant;
    } else {
      return colorScheme.onPrimary;
    }
  }

  SystemUiOverlayStyle _getSystemUiOverlayStyle(
    Brightness brightness,
    double probability,
  ) {
    if (brightness == Brightness.light) {
      if (THRESHOLD2 < probability && probability <= THRESHOLD3) {
        return SystemUiOverlayStyle.dark;
      } else {
        return SystemUiOverlayStyle.light;
      }
    } else {
      if (THRESHOLD2 < probability && probability <= THRESHOLD3) {
        return SystemUiOverlayStyle.light;
      } else {
        return SystemUiOverlayStyle.dark;
      }
    }
  }

  Widget _getTitle(
    double probability,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (probability > THRESHOLD4) {
      return Text(
        '매우 위험해요',
        style: textTheme.displaySmall?.copyWith(
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD3) {
      return Text(
        '위험해요',
        style: textTheme.displaySmall?.copyWith(
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD2) {
      return Text(
        '보통이에요',
        style: textTheme.displaySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    } else if (probability > THRESHOLD1) {
      return Text(
        '안전해요',
        style: textTheme.displaySmall?.copyWith(
          color: colorScheme.onPrimary,
        ),
      );
    } else {
      return Text(
        '매우 안전해요',
        style: textTheme.displaySmall?.copyWith(
          color: colorScheme.onPrimary,
        ),
      );
    }
  }

  Widget _getProbability(
    double probability,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (probability > THRESHOLD4) {
      return Text(
        '${probability.toInt()}%',
        style: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD3) {
      return Text(
        '$probability%',
        style: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD2) {
      return Text(
        '$probability%',
        style: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    } else if (probability > THRESHOLD1) {
      return Text(
        '$probability%',
        style: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      );
    } else {
      return Text(
        '$probability%',
        style: textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      );
    }
  }

  Widget _getBody(
    double probability,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (probability > THRESHOLD4) {
      return Text(
        'AI가 아래 문자들을\n위험하다고 판단했어요!',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD3) {
      return Text(
        'AI가 아래 문자들을\n위험하다고 판단했어요!',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD2) {
      return Text(
        'AI가 아래 토큰들을\n기준으로 판단했어요!',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    } else if (probability > THRESHOLD1) {
      return Text(
        'AI가 아래 토큰들을\n안전하다고 판단했어요!',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
      );
    } else {
      return Text(
        'AI가 아래 토큰들을\n안전하다고 판단했어요!',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
      );
    }
  }

  Widget _getLabel(
    List<String> tokens,
    double probability,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (probability > THRESHOLD4) {
      return Text(
        tokens.join(' '),
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD3) {
      return Text(
        tokens.join(' '),
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onTertiary,
        ),
      );
    } else if (probability > THRESHOLD2) {
      return Text(
        tokens.join(' '),
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    } else if (probability > THRESHOLD1) {
      return Text(
        tokens.join(' '),
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
      );
    } else {
      return Text(
        tokens.join(' '),
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onPrimary,
        ),
      );
    }
  }
}

String process(String data) {
  List<String> lines = [];

  int cnt = 0;
  String line = "";
  for (int i = 0; i < data.length; i += 1) {
    if (i == data.length - 1) {
      cnt += 1;
      line += data[i];
      lines.add(line);
    } else if (cnt == 20 || data[i] == '\n') {
      lines.add(line);
      cnt = 1;
      line = data[i];
    } else {
      cnt += 1;
      line += data[i];
    }
  }

  return lines.join('\n');
}
