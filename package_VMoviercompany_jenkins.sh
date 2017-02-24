#!/bin/sh

#需要引入的变量
#USER="/Users/chengqihan"
#项目所在文件夹
#PROJECT_DIR="${USER}/Documents/VMovierProject/vmoviercompany"
#Project的configuration,Xcode模板创建项目的时候会自动生成Debug/Release 两个Configuration
#并且Debug的配置下,Xcode默认会生成一个DEBUG=1的宏,注意别搞乱了。
#CONFIGRATION="Debug"

#<一>-------定义一些常量
WORK_SPACE="NSMPlayer.xcworkspace"


#SCHEME名字
#SCHEME="MagicBox"
#Xcode编译后,Build文件夹下app的全名
#APPSOURCENAME="${SCHEME}.app"
#储存的app的全名,默认以.ipa后缀命名
IPA_NAME="${SCHEME}_release.ipa"
#存储的ipa存放的目标文件夹
#IPA_DESTINATION_DIERECTORY="${USER}/Desktop/IPA"
#存储的ipa存放的目标文件
#IPA_DESTINATION_FILE="${IPA_DESTINATION_DIERECTORY}/${IPA_NAME}"

#这个很重要,需要在Xcode的编译结果放在自定义的文件夹
#customBuildPath="${USER}/Desktop/CnepayV2Build"
#
BUILD_DIR="${SCHEME}_Build"
echo "----------------------------------------${WORKSPACE}"
echo "PATH:"$PATH
cd ${WORKSPACE}/Example

rm -rf ${WORKSPACE}/Example/Pods

pod repo update vmovier-scm-nsm-specs
pod repo update taobao-baichuansdk-alibcspecs
pod repo update vmovier-scm-im3-magicboxspecs
pod install

set -e

#xcodebuild -list  -workspace $WORK_SPACE
#rm -rf $customBuildPath
rm -rf $BUILD_DIR
xcodebuild  -scheme $SCHEME  clean

#<二>-------版本号修改

#1、从plist中读取到CFBundleVersion对应的Key
#BuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $INFOPLIST_FILE`
##2、使用表达式进行加法运算
#BuildVersion=`expr $BuildVersion + 1`

#3、取出VersionString
#mainVersion="3.1.1"

#4、截取从左第四位后面的字符串[也就是从第五位开始],然后
VersionString="${mainVersion}.${BUILD_NUMBER}"
echo ${VersionString} > ${WORKSPACE}/version.txt



#证书信息
DEVELOP_IDENTITY="iPhone Distribution: Honorary Academy Ltd. (7GL725C6FL)"
DEVELOPMENT_TEAM='7GL725C6FL'
#描述文件
PROFILE="69bc3f2c-7f66-48fa-9f34-731c1e8335bb"
PROFILENAME='XC iOS Ad Hoc: *'
#Info.plist的文件路径
INFOPLIST_FILE="${WORKSPACE}/Example/NSMPlayer/NSMPlayer-Info.plist"




set -e

# /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $VersionString" $INFOPLIST_FILE
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" $INFOPLIST_FILE
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $mainVersion" $INFOPLIST_FILE


#其中，-workspace说明是对工作空间进行编译，-scheme指定工程中配置的scheme，这里所取的值就是我们自己工程所一定的scheme。编译工作空间和编译工程不同的地方就是，编译工程默认会在工程跟路径下生成名为“build”的文件夹，而编译工作空间则不会，所以使用CONFIGURATION_BUILD_DIR来显式指定输出编译后的文件路径

#<三>-------执行XcodeBuild
#"$DEVELOP_IDENTITY" 解决空格问题
#xcodebuild -workspace $WORK_SPACE -scheme $SCHEME -configuration ${CONFIGRATION} CONFIGURATION_BUILD_DIR=$customBuildPath ONLY_ACTIVE_ARCH=NO PRODUCT_BUNDLE_IDENTIFIER=$BUNDLEID  PROVISIONING_PROFILE="$PROFILE" CODE_SIGN_IDENTITY="$DEVELOP_IDENTITY"
#执行ARCHIVE:

xcodebuild -scheme $SCHEME -archivePath $BUILD_DIR/${SCHEME}.xcarchive  archive PROVISIONING_PROFILE_SPECIFIER="$PROFILENAME" DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" CODE_SIGN_IDENTITY="$DEVELOP_IDENTITY" ONLY_ACTIVE_ARCH=NO
set -e
#导出IPA:
xcodebuild -exportArchive -exportFormat IPA -archivePath $BUILD_DIR/${SCHEME}.xcarchive -exportPath $BUILD_DIR/${IPA_NAME} -exportProvisioningProfile "${PROFILENAME}"
set -e
#<四>-------打包
#mkdir -p ${IPA_DESTINATION_DIERECTORY}
#xcrun -sdk iphoneos PackageApplication -v $customBuildPath/$APPSOURCENAME -o $IPA_DESTINATION_FILE
#xcrun -sdk iphoneos PackageApplication -v $customBuildPath/$APPSOURCENAME -o $IPA_DESTINATION_FILE --sign "${DEVELOP_IDENTITY}" --embed "${PROFILE}"
#<五>-------上传文件
#cd $IPA_DESTINATION_DIERECTORY
cd $BUILD_DIR
#
#

/usr/local/bin/fir publish ${IPA_NAME} -T 5c49acf779f0f4c154fea4689566d880 -c "${LOG_FIR}"


#if [ $SCHEME = "MagicBoxTest" ]
#then
#echo "----------------------------------------MagicBoxTest"

#curl -F "file=@${IPA_NAME}" -F "uKey=f8979cf42be3d9ac2a565edb27e07287" -F "_api_key=e05489b69dc7521ec57d313e325be22a" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload
#fir publish ${IPA_NAME} -T 5c49acf779f0f4c154fea4689566d880

#elif [ $SCHEME = "MagicBox" ]
#then
#echo "----------------------------------------MagicBox"
#fir publish ${IPA_NAME} -T 5c49acf779f0f4c154fea4689566d880

#else
#echo "----------------------------------------OtherScheme"

#curl -F "file=@${IPA_NAME}" -F "uKey=7e74fae182d6fb97c48266b5ed279ed0" -F "_api_key=a410fb19690fdec0c7801434c200e9d3" -F "publishRange=2" http://www.pgyer.com/apiv1/app/upload
#fi
