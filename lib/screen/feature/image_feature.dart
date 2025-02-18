import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controller/image_controller.dart';
import '../../helper/global.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  final _c = ImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Creator'),
        actions: [
          Obx(() => Visibility(
                visible: _c.status == Status.complete,
                child: IconButton(
                  padding: const EdgeInsets.only(right: 6),
                  onPressed: _c.shareImage,
                  icon: const Icon(Icons.share),
                ),
              ))
        ],
      ),

      floatingActionButton: Obx(() => Visibility(
            visible: _c.status == Status.complete,
            child: Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: FloatingActionButton(
                onPressed: _c.downloadImage,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: const Icon(Icons.save_alt_rounded, size: 26),
              ),
            ),
          )),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04,
          vertical: mq.height * 0.02,
        ),
        children: [
          TextFormField(
            controller: _c.textC,
            textAlign: TextAlign.center,
            minLines: 2,
            maxLines: null,
            onTapOutside: (e) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              hintText:
                  'Imagine something wonderful & innovative\nType here & I will create for you 😃',
              hintStyle: TextStyle(fontSize: 13.5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),

          SizedBox(height: mq.height * .015),

          Container(
            height: mq.height * .5,
            alignment: Alignment.center,
            child: Obx(() => _aiImage()),
          ),

          Obx(() => Visibility(
                visible: _c.imageList.isNotEmpty,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(bottom: mq.height * .03),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _c.imageList
                        .map((e) => GestureDetector(
                              onTap: () => _c.url.value = e,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: CachedNetworkImage(
                                  imageUrl: e,
                                  height: 100,
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )),

          CustomBtn(onTap: _c.searchAiImage, text: 'Create'),
        ],
      ),
    );
  }

  Widget _aiImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: switch (_c.status.value) {
        Status.none =>
          Lottie.asset('assets/lottie/ai_sit.json', height: mq.height * .3),
        Status.loading => const CustomLoading(),
        Status.complete => CachedNetworkImage(
            imageUrl: _c.url.value,
            placeholder: (context, url) => const CustomLoading(),
            errorWidget: (context, url, error) => const SizedBox(),
          ),
      },
    );
  }
}
