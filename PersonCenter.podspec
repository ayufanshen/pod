#
#  Be sure to run `pod spec lint model.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZCPersonCenter"
  s.version      = "0.1.0"
  s.summary      = "个人中心模块"

  s.description  = <<-DESC
                    个人中心模块
                   DESC

  s.homepage     = "http://www.zuche.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "fanshen" => "fanshen@zuche.com" }
  s.platform     = :ios, "7.0"
  s.requires_arc = true

  s.source  = { :git => "https://github.com/ayufanshen/pod.git", :tag => s.version,:submodules => true }


  s.source_files        = 'ZCPersonCenter/Define.{h,m}'
  s.public_header_files = 'ZCPersonCenter/Define.h'

  s.xcconfig = { "HEADER_SEARCH_PATHS" => '"$(SRCROOT)/../AutoRental/**"'}
  s.dependency "JSONModel"


    s.subspec 'ViewModels' do |ss|

        ss.source_files = 'ZCPersonCenter/ViewModels/ZCMyAccountViewModel.{h,m}'
        ss.public_header_files = 'ZCPersonCenter/ViewModels/ZCMyAccountViewModel.h'
        ss.xcconfig = { "HEADER_SEARCH_PATHS" => '"$(SRCROOT)/../AutoRental/**"'}

    end

    s.subspec 'Views' do |ss|

        ss.source_files = 'ZCPersonCenter/View/{ZCMyAccountHelpTableViewCell,ZCMyAccountItemBtn,ZCMyAccountMatterTableViewCell,ZCMyAccountPrivilegeTableViewCell,ZCMyAccountTableHeaderView,ZCMyAccountTableViewCell,ZCMyAccountWalletTableViewCell}.{h,m}'
        ss.public_header_files = 'ZCPersonCenter/View/{ZCMyAccountHelpTableViewCell,ZCMyAccountItemBtn,ZCMyAccountMatterTableViewCell,ZCMyAccountPrivilegeTableViewCell,ZCMyAccountTableHeaderView,ZCMyAccountTableViewCell,ZCMyAccountWalletTableViewCell}.h'
        # ss.xcconfig = { "HEADER_SEARCH_PATHS" => '"$(SRCROOT)/../AutoRental/**"'}

    end

    s.subspec 'ViewController' do |ss|

        ss.source_files = 'ZCPersonCenter/ViewController/ZCMyAccountViewController.{h,m}'
        ss.public_header_files = 'ZCPersonCenter/ViewController/ZCMyAccountViewController.h'
        #ss.xcconfig = { "HEADER_SEARCH_PATHS" => '"$(SRCROOT)/../AutoRental/**"'}

    end

    s.subspec 'Models' do |ss|

        ss.source_files = 'ZCPersonCenter/Models/{HelpUrls,PeccancyModel,ZCMyAccountModel}.{h,m}'
        ss.public_header_files = 'ZCPersonCenter/Models/{HelpUrls,PeccancyModel,ZCMyAccountModel}.h'
        #ss.xcconfig = { "HEADER_SEARCH_PATHS" => '"$(SRCROOT)/../AutoRental/**"'}

    end


end
