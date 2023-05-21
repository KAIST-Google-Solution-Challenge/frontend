import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/call_controller.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/model/setting_model.dart';
import 'package:the_voice/util/constant.dart';

class CallAnalysisView extends StatefulWidget {
  final String number;
  final String datetime;

  const CallAnalysisView({
    super.key,
    required this.number,
    required this.datetime,
  });

  @override
  State<CallAnalysisView> createState() => _CallAnalysisViewState();
}

class _CallAnalysisViewState extends State<CallAnalysisView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingModel sm = context.watch<SettingModel>();
    bool largeFont = sm.largeFont;
    bool brightness = sm.brightness == Brightness.light;
    bool lang = sm.language == Language.english;

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
              ? 'AI Detected\nBelow Tokens Very Dangerous!'
              : 'AI가 아래 토큰들을\n매우 위험하다고 판단했어요!',
          style: onTertiary,
        );
      } else if (probability > THRESHOLD3) {
        return Text(
          lang
              ? 'AI Detected\nBelow Tokens Dangerous!'
              : 'AI가 아래 토큰들을\n위험하다고 판단했어요!',
          style: onTertiary,
        );
      } else if (probability > THRESHOLD2) {
        return Text(
          lang
              ? 'AI Detected\nBelow Tokens Normal!'
              : 'AI가 아래 토큰들을\n기준으로 판단했어요!',
          style: onSurfaceVariant,
        );
      } else if (probability > THRESHOLD1) {
        return Text(
          lang
              ? 'AI Detected\nBelow Tokens Safe!'
              : 'AI가 아래 토큰들을\n안전하다고 판단했어요!',
          style: onPrimary,
        );
      } else {
        return Text(
          lang
              ? 'AI Detected\nBelow Tokens Very Safe!'
              : 'AI가 아래 토큰들을\n매우 안전하다고 판단했어요!',
          style: onPrimary,
        );
      }
    }

    Widget getLabel(List<String> tokens, double probability) {
      TextStyle? onTertiary = largeFont
          ? tt.titleLarge?.copyWith(color: cs.onTertiary)
          : tt.bodyLarge?.copyWith(color: cs.onTertiary);
      TextStyle? onSurfaceVariant = largeFont
          ? tt.titleLarge?.copyWith(color: cs.onSurfaceVariant)
          : tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant);
      TextStyle? onPrimary = largeFont
          ? tt.titleLarge?.copyWith(color: cs.onPrimary)
          : tt.bodyLarge?.copyWith(color: cs.onPrimary);

      if (probability > THRESHOLD4) {
        return Text(tokens.join(' '), style: onTertiary);
      } else if (probability > THRESHOLD3) {
        return Text(tokens.join(' '), style: onTertiary);
      } else if (probability > THRESHOLD2) {
        return Text(tokens.join(' '), style: onSurfaceVariant);
      } else if (probability > THRESHOLD1) {
        return Text(tokens.join(' '), style: onPrimary);
      } else {
        return Text(tokens.join(' '), style: onPrimary);
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

    Widget buildBar() {
      TonalPalette toTonalPallete(Color color) {
        final hct = Hct.fromInt(color.value);
        return TonalPalette.of(hct.hue, hct.chroma);
      }

      return Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 24,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: cs.primary,
                      child: Center(
                        child: Text(
                          '1',
                          style: tt.labelLarge?.copyWith(color: cs.onPrimary),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(toTonalPallete(cs.primary).get(60)),
                      child: Center(
                        child: Text(
                          '2',
                          style: tt.labelLarge?.copyWith(color: cs.onPrimary),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: cs.surfaceVariant,
                      child: Center(
                        child: Text(
                          '3',
                          style: tt.labelLarge
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(toTonalPallete(cs.tertiary).get(60)),
                      child: Center(
                        child: Text(
                          '4',
                          style: tt.labelLarge?.copyWith(color: cs.onTertiary),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: cs.tertiary,
                      child: Center(
                        child: Text(
                          '5',
                          style: tt.labelLarge?.copyWith(color: cs.onTertiary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      );
    }

    Widget buildBody(double probability) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitle(probability),
                  const SizedBox(height: 8),
                  getProbability(probability),
                  const SizedBox(height: 32),
                  const Divider(endIndent: 128),
                  const SizedBox(height: 32),
                  getBody(probability),
                  const SizedBox(height: 8),
                  getLabel(
                    ['2023', 'Google', 'Solution', 'Challenge'],
                    probability,
                  ),
                ],
              ),
              buildBar(),
            ],
          ),
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
      future: CallController.analyze(widget.number, widget.datetime),
      builder: (_, snapshot) {
        // Debug
        // snapshot = const AsyncSnapshot.withData(ConnectionState.done, 3);

        if (snapshot.hasData) {
          double probability = snapshot.data!;

          if (probability >= 0) {
            return Scaffold(
              backgroundColor: getBackgroundColor(probability),
              appBar: buildAppBar(probability),
              body: buildBody(probability),
            );
          } else {
            return buildError(probability);
          }
        } else {
          return buildLoading();
        }
      },
    );
  }
}
