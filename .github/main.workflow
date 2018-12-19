workflow "New workflow" {
  on = "push"
  resolves = ["swift-4.0", "swift-4.1", "swift-4.2"]
}

action "swift-4.0" {
  uses = "docker://norionomura/swiftlint:swift-4.0"
  runs = "swift"
  args = "test"
}

action "swift-4.1" {
  uses = "docker://norionomura/swiftlint:swift-4.1"
  runs = "swift"
  args = "test"
}

action "swift-4.2" {
  uses = "docker://norionomura/swiftlint:swift-4.2"
  runs = "swift"
  args = "test"
}
