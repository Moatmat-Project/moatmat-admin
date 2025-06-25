import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/functions/pdf/export_qr_codes_pdf.dart';
import 'package:moatmat_admin/Presentation/codes/state/codes/codes_cubit.dart';
import 'package:moatmat_admin/Presentation/codes/views/code_v.dart';
import 'package:moatmat_admin/Presentation/codes/views/generate_code_v.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Core/resources/colors_r.dart';

class CodesViewManager extends StatefulWidget {
  const CodesViewManager({super.key});

  @override
  State<CodesViewManager> createState() => _CodesViewManagerState();
}

class _CodesViewManagerState extends State<CodesViewManager> {
  late final PageController _pageController;
  List<ScreenshotController> controllers = [];
  int current = 1, last = 1;
  bool screenshotLoading = false, pdfLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CodesCubit>().init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controllers.isEmpty) {
      controllers = List.generate(
        context.read<CodesCubit>().codes.length,
        (index) => ScreenshotController(),
      );
    }
  }

  saveScreenShots() async {
    setState(() {
      screenshotLoading = true;
    });

    List<XFile> files = [];
    Rect rect = getRect();
    int numberOfPages = controllers.length;

    for (int i = 0; i < numberOfPages; i++) {
      //
      Completer<void> completer = Completer<void>();
      //
      try {
        //
        _pageController.jumpToPage(i);
        //
        var value = await controllers[i].capture();
        //
        if (value == null) {
          debugPrint("Screenshot capture failed for page $i.");
          completer.complete();
          continue;
        }
        //
        final filePath = await getFilePath();
        //
        await XFile.fromData(value).saveTo(filePath);
        //
        files.add(XFile(filePath));
        //
        debugPrint("Screenshot saved for page $i.");
      } catch (e) {
        debugPrint("Error capturing screenshot for page $i: $e");
      } finally {
        completer.complete();
      }

      await completer.future;
    }
    setState(() {
      screenshotLoading = false;
    });
    if (files.isNotEmpty) {
      try {
        await Share.shareXFiles(files, sharePositionOrigin: rect);
      } catch (e) {
        debugPrint("Error sharing files: $e");
      }
    }
  }

  Rect getRect() {
    return Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
    );
  }

  Future<String> getFilePath() async {
    //
    Directory? externalDir;
    //
    if (Platform.isIOS) {
      externalDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      externalDir = await getExternalStorageDirectory();
    } else {
      externalDir = await getApplicationSupportDirectory();
    }
    //
    final ts = DateTime.now().toIso8601String();
    //
    final filePath = "${externalDir!.path}/$ts.png";
    //
    return filePath;
  }

  Future exportCodes() async {
    final bool? onPerPage = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('اختيار طريقة التصدير'),
          content: Text('هل ترغب بوضع كل كود في صفحة منفصلة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('عدة أكواد في صفحة'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('كود في كل صفحة'),
            ),
          ],
        );
      },
    );

    if (onPerPage == null) return; // user closed dialog

    try {
      setState(() {
        pdfLoading = true;
      });

      Uint8List pdfBytes = await exportQRCodesPdf(
        codes: context.read<CodesCubit>().codes,
        onPerPage: onPerPage,
      );
      // save and open file as :
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/codes.pdf');
      await file.writeAsBytes(pdfBytes);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('تم تصدير الملف بنجاح'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await OpenFile.open(file.path);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('فتح'),
                ),
                TextButton(
                  onPressed: () {
                    Share.shareXFiles([XFile(file.path)]);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('مشاركة'),
                ),
              ],
            );
          },
        );
      }
    } finally {
      setState(() {
        pdfLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: BlocBuilder<CodesCubit, CodesState>(
        builder: (context, state) {
          if (state is CodesInitial) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: const GenerateCodeView(),
            );
          } else if (state is CodesGenerateCodes) {
            last = state.codes.length;
            return Scaffold(
              backgroundColor: ColorsResources.primary,
              appBar: AppBar(
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: screenshotLoading ? () {} : saveScreenShots,
                    icon: screenshotLoading
                        ? const CupertinoActivityIndicator(
                            color: ColorsResources.whiteText1,
                          )
                        : const Icon(Icons.save_alt),
                  ),
                  IconButton(
                    onPressed: kDebugMode
                        ? exportCodes
                        : pdfLoading
                            ? () {}
                            : exportCodes,
                    icon: screenshotLoading
                        ? const CupertinoActivityIndicator(
                            color: ColorsResources.whiteText1,
                          )
                        : const Icon(Icons.picture_as_pdf),
                  ),
                ],
                title: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "$current/$last",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    current = value + 1;
                  });
                },
                itemCount: state.codes.length,
                itemBuilder: (context, index) {
                  if (controllers.length != state.codes.length) {
                    controllers.add(ScreenshotController());
                  }
                  return CodeView(
                    codeData: state.codes[index],
                    controller: controllers[index],
                  );
                },
              ),
            );
          } else if (state is CodesError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: Center(
                child: Text(state.error),
              ),
            );
          }
          return Center(
            child: Scaffold(
              backgroundColor: ColorsResources.primary,
              appBar: AppBar(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: const Center(
                child: CupertinoActivityIndicator(
                  color: ColorsResources.whiteText1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/*
cd moatmat_admin && flutter clean && cd ..
cd moatmat_app && flutter clean && cd ..
cd moatmat_teacher && flutter clean && cd ..
cd moatmat_uploader&& flutter clean && cd ..
*/