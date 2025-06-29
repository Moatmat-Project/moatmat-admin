import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_admin/Core/constant/classes_list.dart';
import 'package:moatmat_admin/Core/constant/materials.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/validators/not_empty_v.dart';
import 'package:moatmat_admin/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_admin/Core/widgets/fields/text_input_field.dart';

import '../../../Features/schools/domain/entites/school.dart';
import '../../../Features/tests/domain/entities/mini_test.dart';
import '../../../Presentation/tests/views/pick_mini_test_v.dart';
import '../material_picker_v.dart';
import '../toucheable_tile_widget.dart';
import 'attach_files_v.dart';

class SetInformationView extends StatefulWidget {
  const SetInformationView({
    super.key,
    this.title,
    this.classs,
    this.material,
    this.teacher,
    this.schoolId,
    this.schools,
    this.period,
    this.price,
    this.afterSet,
    this.password,
    this.video,
    this.images,
    this.files,
    this.previous,
    this.isBank = false,
  });
  //
  final String? title;
  final String? classs;
  final String? material;
  final String? teacher;
  final String? schoolId;
  final String? password;
  final int? period;
  final int? price;
  final List<String>? images;
  final List<String>? video;
  final List<String>? files;
  final List<School>? schools;
  final MiniTest? previous;
  final bool isBank;
  //
  final Function({
    required String title,
    required String classs,
    required String material,
    required String teacher,
    required String? schoolId,
    required String? password,
    required int? period,
    required int price,
    required List<String>? images,
    required List<String>? video,
    required List<String>? files,
    MiniTest? previous,
  })? afterSet;
  //
  @override
  State<SetInformationView> createState() => _SetInformationViewState();
}

class _SetInformationViewState extends State<SetInformationView> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? classs;
  String? material;
  String? teacher;
  String? schoolId;
  String? password;
  int? period;
  int? price;
  //
  List<String>? images;
  List<String>? video;
  List<String>? files;
  MiniTest? previous;
  //
  @override
  void initState() {
    title = widget.title;
    classs = widget.classs;
    material = widget.material;
    teacher = widget.teacher;
    schoolId = widget.schoolId;
    password = widget.password;
    period = widget.period;
    price = widget.price;
    video = widget.video;
    images = widget.images;
    files = widget.files;
    previous = widget.previous;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.isBank ? const Text("معلومات البنك الرئيسية") : const Text("معلومات الاختبار الرئيسية"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: widget.isBank ? "عنوان البنك" : "عنوان الاختبار",
                textInputAction: TextInputAction.next,
                initialValue: title,
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  title = p0;
                },
              ),
              const SizedBox(height: SizesResources.s2),
              DropDownWidget(
                hintText: "الصف",
                selectedItem: classs ?? classesLst[classesLst.length - 2],
                items: classesLst,
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  classs = p0;
                },
              ),
              const SizedBox(height: SizesResources.s2),
              DropDownWidget(
                hintText: "المادة",
                selectedItem: material ?? materialsLst.first["name"],
                items: materialsLst.map((e) => e["name"] as String).toList(),
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  material = p0;
                },
              ),
              if (!widget.isBank && widget.schools?.isNotEmpty != null) ...[
                const SizedBox(height: SizesResources.s2),
                DropDownWidget(
                  hintText: "المدرسة : ",
                  selectedItem: widget.schools?.where(((e) => e.id.toString() == schoolId)).firstOrNull?.information.name ?? "غير محدد",
                  items: ["غير محدد"] + widget.schools!.map((e) => e.information.name).toList(),
                  onChanged: (p0) {
                    setState(() {
                      schoolId = widget.schools?.where((e) => e.information.name == p0).firstOrNull?.id.toString();
                    });
                  },
                  onSaved: (p0) {
                    setState(() {
                      schoolId = widget.schools?.where((e) => e.information.name == p0).firstOrNull?.id.toString();
                    });
                  },
                ),
              ],
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: "الاستاذ",
                initialValue: teacher,
                textInputAction: TextInputAction.next,
                validator: (p0) {
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  teacher = p0;
                },
              ),
              if (!widget.isBank) ...[
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  hintText: "الرمز السري",
                  initialValue: password,
                  textInputAction: TextInputAction.next,
                  onSaved: (p0) {
                    password = p0;
                  },
                ),
              ],
              if (!widget.isBank) ...[
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  hintText: "المدة (بالثواني)",
                  initialValue: period?.toString(),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (p0) {
                    if (p0 == null) return null;
                    if (p0 == "") return null;
                    if (p0 == "0") {
                      return "ادخل وقت صالح";
                    }
                    return null;
                  },
                  onSaved: (p0) {
                    if (p0 == null) return;
                    period = int.tryParse(p0);
                  },
                ),
              ],
              const SizedBox(height: SizesResources.s2),
              MyTextFormFieldWidget(
                hintText: "السعر",
                initialValue: price?.toString(),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (p0) {
                  int? price = int.tryParse(p0 ?? "0");
                  if (price != null) {
                    if (price > 200000) {
                      return "يرجى ادخال سعر ادنى من 200,000";
                    }
                  }
                  return notEmptyValidator(text: p0);
                },
                onSaved: (p0) {
                  if (p0 == null) return;
                  price = int.tryParse(p0);
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TouchableTileWidget(
                title: "ارفاق صور",
                subTitle: "عدد الصور : ${(images ?? []).length}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AttachFilesView(
                        type: FileType.image,
                        assets: images ?? [],
                        onSave: (res) {
                          setState(() {
                            images = res;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TouchableTileWidget(
                title: "ارفاق مقاطع فيديو",
                subTitle: "عدد مقاطع الفيديو : ${(video ?? []).length}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AttachFilesView(
                        type: FileType.video,
                        assets: video ?? [],
                        onSave: (res) {
                          setState(() {
                            video = res;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: SizesResources.s2),
              TouchableTileWidget(
                title: "ارفاق ملفات PDF",
                subTitle: "عدد الملفات : ${(files ?? []).length}",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AttachFilesView(
                        type: FileType.any,
                        assets: files ?? [],
                        onSave: (res) {
                          setState(() {
                            files = res;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              if (!widget.isBank)
                TouchableTileWidget(
                  title: "تحديد اختبار شرطي",
                  subTitle: previous?.title ?? "لم يتم التحديد",
                  icon: previous != null
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              previous = null;
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MaterialPickerView(
                          onPick: (p0) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => PickMiniTestView(
                                  material: p0,
                                  afterPIck: (p1) {
                                    setState(() {
                                      previous = p1;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "تعيين المعلومات",
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              widget.afterSet!(
                title: title!,
                classs: classs!,
                material: material!,
                schoolId: schoolId,
                teacher: teacher!,
                password: password,
                period: period,
                price: price!,
                video: video,
                files: files,
                previous: previous,
                images: images,
              );
            }
          },
        ),
      ),
    );
  }
}
