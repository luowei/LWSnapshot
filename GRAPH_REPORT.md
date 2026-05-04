# Graph Report - /Users/luowei/projects/libs/LWSnapshot  (2026-05-04)

## Corpus Check
- Corpus is ~9,330 words - fits in a single context window. You may not need a graph.

## Summary
- 128 nodes · 150 edges · 11 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]

## God Nodes (most connected - your core abstractions)
1. `LWSnapshotMaskView` - 27 edges
2. `PointLocation` - 13 edges
3. `SnapshotExampleViewController` - 8 edges
4. `LWAppDelegate` - 7 edges
5. `LWViewController` - 7 edges
6. `UIView` - 7 edges
7. `Coordinator` - 7 edges
8. `LWSnapshotView` - 7 edges
9. `SnapshotViewController` - 5 edges
10. `Tests` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities (16 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.11
Nodes (10): LWSnapshotMaskView, -drawRect, -drawRectangleWithFrame, -hideSnapshotMaskInView, -initWithFrame, -locationOfPoint, -showSnapshotMaskInView, -touchesBeganwithEvent (+2 more)

### Community 1 - "Community 1"
Cohesion: 0.23
Nodes (12): App, ContentView, HomeView, SettingsView, SnapshotExampleApp, SnapshotExampleView1, SnapshotExampleView2, SnapshotExampleView3 (+4 more)

### Community 2 - "Community 2"
Cohesion: 0.15
Nodes (13): PointLocation, inControl, onBottomEdge, onControl, onLeftBottomCorner, onLeftEdge, onLeftTopCorner, onRightBottomCorner (+5 more)

### Community 3 - "Community 3"
Cohesion: 0.21
Nodes (5): LWSnapshotView, SnapshotModifier, View, UIViewRepresentable, ViewModifier

### Community 4 - "Community 4"
Cohesion: 0.24
Nodes (4): Coordinator, SnapshotViewController, NSObject, UIViewControllerRepresentable

### Community 5 - "Community 5"
Cohesion: 0.22
Nodes (3): UIView, -snapshot_imageInRect, -snapshot_superViewWithClass

### Community 6 - "Community 6"
Cohesion: 0.29
Nodes (3): LWSnapshot, UIView, UIViewController

### Community 8 - "Community 8"
Cohesion: 0.25
Nodes (7): LWAppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 9 - "Community 9"
Cohesion: 0.25
Nodes (7): LWViewController, -appDidTakeScreenshotNotification, -btnAction, -dealloc, -longPressGestureAction, -showSnapshotView, -viewDidLoad

### Community 10 - "Community 10"
Cohesion: 0.4
Nodes (4): Tests, -setUp, -tearDown, -testExample

## Knowledge Gaps
- **36 isolated node(s):** `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive`, `-applicationDidEnterBackground`, `-applicationWillEnterForeground`, `-applicationDidBecomeActive` (+31 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LWSnapshotMaskView` connect `Community 0` to `Community 5`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `PointLocation` connect `Community 2` to `Community 5`?**
  _High betweenness centrality (0.059) - this node is a cross-community bridge._
- **What connects `-applicationdidFinishLaunchingWithOptions`, `-applicationWillResignActive`, `-applicationDidEnterBackground` to the rest of the system?**
  _36 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.11 - nodes in this community are weakly interconnected._