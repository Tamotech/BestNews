#! /bin/bash
# created by Ficow Shen
#$1 r release d debug
echo "参数========="
echo "$0 $1"
#工程绝对路径
project_path=$(pwd)

#工程名
project_name=BestNews

#打包模式 Debug/Release
development_mode=Debug
if $1=="r" then
    development_mode=release

#scheme名
scheme_name=BestNews

#build文件夹路径
build_path=${project_path}/build

#plist文件所在路径
exportOptionsPlistPath=${project_path}/exportOptions.plist

#导出.ipa文件所在路径
exportFilePath=${project_path}/ipa/${development_mode}


echo '*** 正在 清理工程 ***'
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit 
echo '*** 清理完成 ***'



echo '*** 正在 编译工程 For '${development_mode}
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive -quiet  || exit
echo '*** 编译完成 ***'



echo '*** 正在 打包 ***'
xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

if [ -e $exportFilePath/$scheme_name.ipa ]; then
    echo "*** .ipa文件已导出 ***"
    open $exportFilePath
else
    echo "*** 创建.ipa文件失败 ***"
fi
echo '*** 打包完成 ***'