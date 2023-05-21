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
    SettingModel sm = context.watch<SettingModel>();
    bool lang = sm.language == Language.english;
    bool brightness = sm.brightness == Brightness.light;

    SystemUiOverlayStyle getSystemUiOverlayStyle(double probability) {
      if (brightness) {
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

    Widget getTitle(double probability) {
      if (probability > THRESHOLD4) {
        return Text(
          lang ? 'Very Dangerous' : '매우 위험해요',
          style: tt.displaySmall?.copyWith(color: cs.onTertiary),
        );
      } else if (probability > THRESHOLD3) {
        return Text(
          lang ? 'Dangerous' : '위험해요',
          style: tt.displaySmall?.copyWith(color: cs.onTertiary),
        );
      } else if (probability > THRESHOLD2) {
        return Text(
          lang ? 'Normal' : '보통이에요',
          style: tt.displaySmall?.copyWith(color: cs.onSurfaceVariant),
        );
      } else if (probability > THRESHOLD1) {
        return Text(
          lang ? 'Safe' : '안전해요',
          style: tt.displaySmall?.copyWith(color: cs.onPrimary),
        );
      } else {
        return Text(
          lang ? 'Very Safe' : '매우 안전해요',
          style: tt.displaySmall?.copyWith(color: cs.onPrimary),
        );
      }
    }

    Widget getProbability(double probability) {
      if (probability > THRESHOLD4) {
        return Text(
          '${probability.toInt()}%',
          style: tt.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onTertiary,
          ),
        );
      } else if (probability > THRESHOLD3) {
        return Text(
          '${probability.toInt()}%',
          style: tt.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onTertiary,
          ),
        );
      } else if (probability > THRESHOLD2) {
        return Text(
          '${probability.toInt()}%',
          style: tt.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant,
          ),
        );
      } else if (probability > THRESHOLD1) {
        return Text(
          '${probability.toInt()}%',
          style: tt.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onPrimary,
          ),
        );
      } else {
        return Text(
          '${probability.toInt()}%',
          style: tt.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onPrimary,
          ),
        );
      }
    }

    Widget getBody(double probability) {
      if (probability > THRESHOLD4) {
        return Text(
          lang
              ? 'AI Detected Below Tokens\nas Very Dangerous'
              : 'AI가 아래 토큰들을\n매우 위험하다고 판단했어요!',
          style: tt.titleLarge?.copyWith(color: cs.onTertiary),
        );
      } else if (probability > THRESHOLD3) {
        return Text(
          lang
              ? 'AI Detected Below Tokens\nas Dangerous'
              : 'AI가 아래 토큰들을\n위험하다고 판단했어요!',
          style: tt.titleLarge?.copyWith(color: cs.onTertiary),
        );
      } else if (probability > THRESHOLD2) {
        return Text(
          lang
              ? 'AI Detected Below Tokens\nas Normal'
              : 'AI가 아래 토큰들을\n기준으로 판단했어요!',
          style: tt.titleLarge?.copyWith(color: cs.onSurfaceVariant),
        );
      } else if (probability > THRESHOLD1) {
        return Text(
          lang
              ? 'AI Detected Below Tokens\nas Safe'
              : 'AI가 아래 토큰들을\n안전하다고 판단했어요!',
          style: tt.titleLarge?.copyWith(color: cs.onPrimary),
        );
      } else {
        return Text(
          lang
              ? 'AI Detected Below Tokens\nas Very Safe'
              : 'AI가 아래 토큰들을\n매우 안전하다고 판단했어요!',
          style: tt.titleLarge?.copyWith(color: cs.onPrimary),
        );
      }
    }

    Color getBackgroundColor(double probability) {
      TonalPalette toTonalPallete(Color color) {
        final hct = Hct.fromInt(color.value);
        return TonalPalette.of(hct.hue, hct.chroma);
      }

      if (probability > THRESHOLD4) {
        return cs.tertiary;
      } else if (probability > THRESHOLD3) {
        return Color(toTonalPallete(cs.tertiary).get(60));
      } else if (probability > THRESHOLD2) {
        return cs.surfaceVariant;
      } else if (probability > THRESHOLD1) {
        return Color(toTonalPallete(cs.primary).get(60));
      } else {
        return cs.primary;
      }
    }

    Color getOnSurfaceColor(double probability) {
      if (probability > THRESHOLD3) {
        return cs.onTertiary;
      } else if (probability > THRESHOLD2) {
        return cs.onSurfaceVariant;
      } else {
        return cs.onPrimary;
      }
    }

    PreferredSizeWidget buildAppBar(double probability) {
      return AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.number,
          style: TextStyle(color: getOnSurfaceColor(probability)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: getOnSurfaceColor(probability),
        ),
        systemOverlayStyle: getSystemUiOverlayStyle(probability),
      );
    }

    List<Widget> getMessages(Color onSurfaceColor) {
      return List.generate(
        probabilities.length,
        (index) {
          for (int i = 0; i < messages.length; i++) {
            if (probabilities[index]['id'] == messages[i].smsMessage.id!) {
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 0 : 16,
                  bottom: index == probabilities.length - 1 ? 0 : 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        process(messages[i].smsMessage.body!),
                        style: tt.bodyLarge?.copyWith(color: cs.onSurface),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${probabilities[index]['probability'].toInt()}%',
                      style: tt.labelLarge?.copyWith(color: onSurfaceColor),
                    ),
                  ],
                ),
              );
            }
          }

          return const SizedBox();
        },
      );
    }

    Widget buildBody(double probability) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(probability),
            const SizedBox(height: 8),
            getProbability(probability),
            const SizedBox(height: 32),
            const Divider(endIndent: 128),
            const SizedBox(height: 32),
            getBody(probability),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: getMessages(getOnSurfaceColor(probability)),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildError(double errorCode) {
      return Scaffold(
        appBar: BuildAppBar(pushed: true, title: widget.number),
        body: Center(
          child: Builder(
            builder: (_) {
              if (errorCode == ERROR_NOFILE) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ERROR',
                      style: tt.headlineLarge?.copyWith(color: cs.onSurface),
                    ),
                    Text(
                      'NO FILE',
                      style: tt.displayLarge?.copyWith(color: cs.onSurface),
                    )
                  ],
                );
              } else if (errorCode == ERROR_SERVER) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ERROR',
                      style: tt.headlineLarge?.copyWith(color: cs.onSurface),
                    ),
                    Text(
                      'SERVER',
                      style: tt.displayLarge?.copyWith(color: cs.onSurface),
                    )
                  ],
                );
              } else if (errorCode == ERROR_EMPTY) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ERROR',
                      style: tt.headlineLarge?.copyWith(color: cs.onSurface),
                    ),
                    Text(
                      'EMPTY',
                      style: tt.displayLarge?.copyWith(color: cs.onSurface),
                    )
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ERROR',
                      style: tt.headlineLarge?.copyWith(color: cs.onSurface),
                    ),
                    Text(
                      (-errorCode.toInt()).toString(),
                      style: tt.displayLarge?.copyWith(color: cs.onSurface),
                    )
                  ],
                );
              }
            },
          ),
        ),
      );
    }

    Widget buildLoading() {
      return Scaffold(
        appBar: BuildAppBar(pushed: true, title: widget.number),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder(
      future: future(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (probabilities.isNotEmpty) {
            double probability = probabilities[0]['probability'];

            if (probability >= 0) {
              double probability = probabilities[0]['probability'];
              return Scaffold(
                backgroundColor: getBackgroundColor(probability),
                appBar: buildAppBar(probability),
                body: buildBody(probability),
              );
            } else {
              return buildError(probability);
            }
          } else {
            return buildError(ERROR_EMPTY);
          }
        } else {
          return buildLoading();
        }
      },
    );
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
    } else if (cnt == 16 || data[i] == '\n') {
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
