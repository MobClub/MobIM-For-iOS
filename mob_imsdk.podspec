Pod::Spec.new do |s|
s.name                = "mob_imsdk"
s.version             = "1.0.0"
s.summary             = 'A Lite IMSDK Provided By Mob.'
s.license             = 'Copyright © 2012-2017 mob.com'
s.author              = { "MobProducts" => "mobproducts@163.com" }
s.homepage            = 'http://www.mob.com'
s.source              = { :git => "https://github.com/MobClub/MobIM.git", :tag => s.version.to_s }
s.platform            = :ios, '8.0'
s.frameworks          = "JavaScriptCore"
s.libraries           = "z", "stdc++.6.0.9"
s.vendored_frameworks = 'SDK/MobIM/MobIM.framework'
s.dependency 'MOBFoundation'
end
