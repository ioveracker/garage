use_frameworks!

def shared_pods
  pod 'WebIOPi', '= 0.2.0'
end

target 'Garage' do
  shared_pods

  target 'GarageTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

end

target 'GarageWatch Extension' do
  shared_pods
end
