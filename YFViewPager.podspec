Pod::Spec.new do |s|
  s.name         = "YFViewPager"
  s.version      = "3.1.0"
  s.summary      = "一个类似于安卓ViewPager的开源库 - iOS ViewPager 高级库 支持 iPhone/ipad/ipod."
# s.description  = <<-DESC
#                   DESC
  s.homepage     = "https://github.com/DandreYang/YFViewPager"
  s.screenshots  = "https://github.com/saxueyang/YFViewPager/raw/master/YFViewPager/yfviewpager.gif", "https://github.com/saxueyang/YFViewPager/raw/master/Screen%20Shot.png"
  s.license      = "MIT"
  s.author             = { "‘Dandre’" => "mkshow@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/DandreYang/YFViewPager.git", :tag => "#{s.version}" }
  s.source_files  = "YFViewPager/YFViewPager/**/*.{h,m}"
  s.public_header_files = "YFViewPager/YFViewPager/**/*.h"
end
