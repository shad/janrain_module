rm -r build
rm -r com.foodonthetable.janrain-iphone-0.1.zip
./build.py
rm -r tmp
mkdir tmp
unzip -d tmp com.foodonthetable.janrain-iphone-0.1.zip
rm -rf ~/mobile/modules/iphone/com.foodonthetable.janrain
cp -r tmp/modules/iphone/com.foodonthetable.janrain ~/mobile/modules/iphone/
