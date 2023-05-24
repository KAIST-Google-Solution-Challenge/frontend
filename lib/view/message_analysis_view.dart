import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/util/constant.dart';

class MessageAnalysisView extends StatefulWidget {
  final int threadId;

  const MessageAnalysisView({super.key, required this.threadId});

  @override
  State<MessageAnalysisView> createState() => _MessageAnalysisViewState();
}

class _MessageAnalysisViewState extends State<MessageAnalysisView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;
    bool brightness = sm.brightness == Brightness.light;
    bool lang = sm.language == Language.english;

    SmsMessage lastMessage = MessageController.messages[widget.threadId]![0];

    String title =
        lastMessage.name! != '' ? lastMessage.name! : lastMessage.address!;

    List<SmsMessage> requests = MessageController.messages[widget.threadId]!;
    List<dynamic>? responses;

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
      TextStyle? onTertiary = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onTertiary)
          : tt.displaySmall?.copyWith(color: cs.onTertiary);
      TextStyle? onSurfaceVariant = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onSurfaceVariant)
          : tt.displaySmall?.copyWith(color: cs.onSurfaceVariant);
      TextStyle? onPrimary = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onPrimary)
          : tt.displaySmall?.copyWith(color: cs.onPrimary);

      if (probability > THRESHOLD4) {
        return Text(lang ? 'Very Dangerous' : '매우 위험해요', style: onTertiary);
      } else if (probability > THRESHOLD3) {
        return Text(lang ? 'Dangerous' : '위험해요', style: onTertiary);
      } else if (probability > THRESHOLD2) {
        return Text(lang ? 'Normal' : '보통이에요', style: onSurfaceVariant);
      } else if (probability > THRESHOLD1) {
        return Text(lang ? 'Safe' : '안전해요', style: onPrimary);
      } else {
        return Text(lang ? 'Very Safe' : '매우 안전해요', style: onPrimary);
      }
    }

    Widget getProbability(double probability) {
      TextStyle? onTertiary = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onTertiary,
      );
      TextStyle? onSurfaceVariant = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onSurfaceVariant,
      );
      TextStyle? onPrimary = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onPrimary,
      );

      if (probability > THRESHOLD4) {
        return Text('${probability.toInt()}%', style: onTertiary);
      } else if (probability > THRESHOLD3) {
        return Text('${probability.toInt()}%', style: onTertiary);
      } else if (probability > THRESHOLD2) {
        return Text('${probability.toInt()}%', style: onSurfaceVariant);
      } else if (probability > THRESHOLD1) {
        return Text('${probability.toInt()}%', style: onPrimary);
      } else {
        return Text('${probability.toInt()}%', style: onPrimary);
      }
    }

    Widget getBody(double probability) {
      TextStyle? onTertiary = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onTertiary)
          : tt.titleLarge?.copyWith(color: cs.onTertiary);
      TextStyle? onSurfaceVariant = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onSurfaceVariant)
          : tt.titleLarge?.copyWith(color: cs.onSurfaceVariant);
      TextStyle? onPrimary = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onPrimary)
          : tt.titleLarge?.copyWith(color: cs.onPrimary);

      if (probability > THRESHOLD4) {
        return Text(
          lang
              ? 'AI Detected Below\nMessages Very Dangerous!'
              : 'AI가 아래 메시지들을\n매우 위험하다고 판단했어요!',
          style: onTertiary,
        );
      } else if (probability > THRESHOLD3) {
        return Text(
          lang
              ? 'AI Detected Below\nMessages Dangerous!'
              : 'AI가 아래 메시지들을\n위험하다고 판단했어요!',
          style: onTertiary,
        );
      } else if (probability > THRESHOLD2) {
        return Text(
          lang
              ? 'AI Detected Below\nMessages Normal!'
              : 'AI가 아래 메시지들을\n기준으로 판단했어요!',
          style: onSurfaceVariant,
        );
      } else if (probability > THRESHOLD1) {
        return Text(
          lang
              ? 'AI Detected Below\nMessages Safe!'
              : 'AI가 아래 메시지들을\n안전하다고 판단했어요!',
          style: onPrimary,
        );
      } else {
        return Text(
          lang
              ? 'AI Detected Below\nMessages Very Safe!'
              : 'AI가 아래 메시지들을\n매우 안전하다고 판단했어요!',
          style: onPrimary,
        );
      }
    }

    String getError(int statusCode) {
      if (statusCode == ERROR_EMPTY) {
        return 'EMPTY';
      } else if (statusCode == ERROR_SERVER) {
        return 'SERVER';
      } else if (statusCode == ERROR_CLIENT) {
        return 'CLIENT';
      } else {
        return 'UNKNOWN';
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
          title,
          style: largeFont
              ? tt.headlineLarge?.copyWith(
                  color: getOnSurfaceColor(probability),
                )
              : tt.titleLarge?.copyWith(
                  color: getOnSurfaceColor(probability),
                ),
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
        responses!.length,
        (index) {
          for (int i = 0; i < requests.length; i++) {
            if (responses![index]['id'] == requests[i].id!) {
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 0 : 8,
                  bottom: index == responses!.length - 1 ? 0 : 8,
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
                        process(
                          requests[i].body!,
                          largeFont ? 12 : 16,
                        ),
                        style: largeFont
                            ? tt.titleLarge?.copyWith(color: cs.onSurface)
                            : tt.bodyLarge?.copyWith(color: cs.onSurface),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${responses![index]['probability'].toInt()}%',
                      style: largeFont
                          ? tt.titleLarge?.copyWith(color: onSurfaceColor)
                          : tt.labelLarge?.copyWith(color: onSurfaceColor),
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

    Widget buildError(int statusCode) {
      return Scaffold(
        appBar: BuildAppBar(pushed: true, title: title),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ERROR',
                style: tt.headlineLarge?.copyWith(color: cs.onSurface),
              ),
              Text(
                getError(statusCode),
                style: tt.displayLarge?.copyWith(color: cs.onSurface),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildLoading() {
      return Scaffold(
        appBar: BuildAppBar(pushed: true, title: title),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder(
      future: MessageController.analyzeMessages(requests.sublist(0, 16)),
      builder: (_, snapshot) {
        responses = snapshot.data;

        if (snapshot.hasData) {
          if (responses!.isNotEmpty) {
            int statusCode = responses![0]['statusCode'];

            if (statusCode == 200) {
              double probability = avg(
                List.generate(
                  responses!.length,
                  (i) => responses![i]['probability'],
                ),
              );

              return Scaffold(
                backgroundColor: getBackgroundColor(probability),
                appBar: buildAppBar(probability),
                body: buildBody(probability),
              );
            } else {
              return buildError(responses![0]['statusCode']);
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

String process(String data, int num) {
  List<String> lines = [];

  int cnt = 0;
  String line = "";
  for (int i = 0; i < data.length; i += 1) {
    if (i == data.length - 1) {
      cnt += 1;
      line += data[i];
      lines.add(line);
    } else if (cnt == num || data[i] == '\n') {
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

double avg(List iter) {
  double sum = 0;

  for (double e in iter) {
    sum += e;
  }

  return sum / iter.length;
}
