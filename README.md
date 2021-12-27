# SimpleChart

SimpleChart is a package developed for our company, with the intent of sharing to the developer community. As you may know, there are already a lot of SwiftUI charting library. This is yet another implementations.

Supported platforms include iOS v13, macOS v10.15, tvOS v13, watchOS v6, macCatalyst v.13. Basically all SwiftUI support platforms are supported.

What makes this package different? SimpleChart provides utility methods for you to create the chartData list, which is the only necessary parameter for all of our charts config object. To use the provided convinence method, import SimpleChart, call SCManager and the associated methods. SCManager is the manager for all methods provided by this package. SCManager is a shared instance and it is a singleton object.

Available Charts:

1. Bar Chart
2. Histogram
3. Line Chart
4. Quad Curve (curved version of line chart)
5. Range Chart (a chart to represent the range of data within the same time period, similar to heart rate range representation in Apple Health app)

Sample:
<img width="344" alt="Screenshot 2021-12-27 at 19 26 29" src="https://user-images.githubusercontent.com/75328711/147467866-aa103159-2f11-454d-9147-0a09124488a4.png">


All convinence method either accept [Double] or [Int] as an input, except for the following methods:

```swift
SCManager.getRangeChartData()
```

This methods accept both [Double] or [Int], as the “lower” and “upper” argument, along with a list of named tuple (lower: [Double], upper: [Double]) or (lower: [Int], upper: [Int]) for the “data” argument.

All customizations will be done in the config object. You may see the initializer for all of the possible customizations. A special case is that the baseZero might be overrided by the initializer if the data input include negative number.

Pending to implement:

1. Legend and associated customizations
2. Label for each axis

The above customizations are already included in the config object, but not implemented in the actual chart views. More customizations will be coming and support and pull request are welcome.
