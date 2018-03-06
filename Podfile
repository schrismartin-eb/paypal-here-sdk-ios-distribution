platform :ios, '8.1'

inhibit_all_warnings!
use_frameworks!

workspace 'PPHSDKSampleApp'

target 'PPHSDKSampleApp' do
    project 'PPHSDKSampleApp.xcodeproj'
    # pod 'PayPalHereSDKv2'
    pod 'PayPalRetailSDK', path:'../..' #this is the path for the rsdk. Uncomment PayPalHereSDKv2 to use the public cocoapod
end


post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name == "PayPalRetailSDK"
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'INCLUDE_ROAM_AUDIO=1']
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
end
