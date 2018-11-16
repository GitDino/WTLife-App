# 删除 build 文件
if [[ -d build ]];
then
rm -rf build -r
fi

# 当前目录是否存在IPADir文件，不存则创建
if [ ! -d ./IPA ];
then
mkdir -p IPA;
fi

# 返回上一级目录
cd ..

# 工程绝对路径
project_path=$(cd `dirname $0`; pwd)

project_name=wutong
scheme_name=wutong

# build文件夹（存放.xcarchive文件）路径
build_path=${project_path}/buildTool/build

development_mode=Debug
exportOptionsPlistPath=${project_path}/buildTool/exportAdHoc.plist

# 获取导出 ipa 包路径
exportIpaPath=${project_path}/buildTool/IPA/${development_mode}

echo ' ++++++++++++++++ '
echo ' + 正在清理工程 + '
echo ' ++++++++++++++++ '
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit

echo ' +++++++++++++ '
echo ' + 清理完成 + '
echo ' +++++++++++++ '

# 编译工程并将 .xcarchive 文件存入 build_path 路径中
echo ' +++++++++++++ '
echo ' 正在编译工程: '${development_mode}
echo ' +++++++++++++ '
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo ' +++++++++++++ '
echo ' + 编译完成 + '
echo ' +++++++++++++ '

echo ' ++++++++++++++++ '
echo ' + 开始ipa打包 + '
echo ' ++++++++++++++++ '
xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
echo ' ++++++++++++++++ '
echo ' + ipa包已导出 + '
echo ' ++++++++++++++++ '
open $exportIpaPath
else
echo ' +++++++++++++++++ '
echo ' + ipa包导出失败 + '
echo ' +++++++++++++++++ '
fi

echo ' +++++++++++++++ '
echo ' + 打包ipa完成 + '
echo ' ++++++++++++++++ '

echo ' +++++++++++++++++ '
echo ' + 开始发布ipa包 + '
echo ' +++++++++++++++++ '

#上传到Fir
# 将XXX替换成自己的Fir平台的token
fir login -T 57600f98793ec86b65820e67788013a2
fir publish $exportIpaPath/$scheme_name.ipa

exit 0
