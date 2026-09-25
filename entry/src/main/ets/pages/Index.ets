import { HomePage } from './HomePage';
import { MenuTabPage } from './MenuTabPage';
import { PlatePage } from './PlatePage';
import { MinePage } from './MinePage';
import { Store } from '../common/Store';

@Entry
@Component
struct Index {
  @StorageLink('mainTabIndex') currentTab: number = 0;
  private controller: TabsController = new TabsController();

  aboutToAppear(): void {
    Store.init();
  }

  @Builder
  TabBarItem(title: string, icon: string, idx: number) {
    Column({ space: 2 }) {
      Text(icon)
        .fontSize(22)
        .fontColor(this.currentTab === idx ? '#FF6B35' : '#9AA0A6')
      Text(title)
        .fontSize(11)
        .fontColor(this.currentTab === idx ? '#FF6B35' : '#9AA0A6')
        .fontWeight(this.currentTab === idx ? FontWeight.Medium : FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Tabs({ index: this.currentTab, controller: this.controller }) {
      TabContent() {
        HomePage()
      }
      .tabBar(this.TabBarItem('避峰', '🏠', 0))

      TabContent() {
        MenuTabPage()
      }
      .tabBar(this.TabBarItem('点餐', '🍱', 1))

      TabContent() {
        PlatePage()
      }
      .tabBar(this.TabBarItem('光盘', '🥗', 2))

      TabContent() {
        MinePage()
      }
      .tabBar(this.TabBarItem('我的', '👤', 3))
    }
    .barPosition(BarPosition.End)
    .barMode(BarMode.Fixed)
    .barHeight(60)
    .scrollable(false)
    .onChange((index: number) => {
      this.currentTab = index;
    })
  }
}
