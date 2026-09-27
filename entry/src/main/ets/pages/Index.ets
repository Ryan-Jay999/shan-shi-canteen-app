import { router } from '@kit.ArkUI';
import { HomePage } from './HomePage';
import { MenuTabPage } from './MenuTabPage';
import { PlatePage } from './PlatePage';
import { MinePage } from './MinePage';
import { Store } from '../common/Store';

// 首次启动隐私授权状态持久化
PersistentStorage.persistProp('privacyAgreed', false);

@Entry
@Component
struct Index {
  @StorageLink('mainTabIndex') currentTab: number = 0;
  @StorageLink('privacyAgreed') privacyAgreed: boolean = false;
  private controller: TabsController = new TabsController();

  aboutToAppear(): void {
    Store.init();
  }

  private toast(msg: string): void {
    this.getUIContext().getPromptAction().showToast({ message: msg });
  }

  @Builder
  TabBarItem(title: string, icon: string, idx: number) {
    Column({ space: 2 }) {
      Text(icon)
        .fontSize(22)
        .fontColor(this.currentTab === idx ? $r('app.color.c_brand') : $r('app.color.c_tab_inactive'))
      Text(title)
        .fontSize(11)
        .fontColor(this.currentTab === idx ? $r('app.color.c_brand') : $r('app.color.c_tab_inactive'))
        .fontWeight(this.currentTab === idx ? FontWeight.Medium : FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 首启隐私政策弹窗
  @Builder
  PrivacyDialog() {
    Column() {
      Column({ space: 12 }) {
        Text('校膳通')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.c_text_primary'))
        Text('隐私政策与用户协议')
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.c_text_primary'))
          .width('100%')
        Text('「校膳通」是一款校园食堂避峰、在线点餐与光盘积分助手（演示版）。' +
          '在使用前，请您阅读并同意以下条款：')
          .fontSize(12)
          .lineHeight(19)
          .fontColor($r('app.color.c_text_secondary'))
          .width('100%')

        Row({ space: 10 }) {
          Text('《用户服务协议》')
            .fontSize(12)
            .fontColor($r('app.color.c_brand'))
            .onClick(() => {
              router.pushUrl({ url: 'pages/AgreementPage', params: { type: 'terms' } });
            })
          Text('《隐私政策》')
            .fontSize(12)
            .fontColor($r('app.color.c_brand'))
            .onClick(() => {
              router.pushUrl({ url: 'pages/AgreementPage', params: { type: 'privacy' } });
            })
        }
        .width('100%')

        Text('我们不会收集或上传您的任何个人信息。您填写的资料以及积分、优惠券与订单记录仅保存在本机，' +
          '可在「我的 → 设置」中一键清除。')
          .fontSize(11)
          .lineHeight(18)
          .fontColor($r('app.color.c_text_tertiary'))
          .width('100%')
          .backgroundColor($r('app.color.c_surface_soft'))
          .padding(10)
          .borderRadius(8)

        Row({ space: 10 }) {
          Button('不同意')
            .fontSize(14)
            .fontColor($r('app.color.c_text_secondary'))
            .backgroundColor($r('app.color.c_chip_bg'))
            .layoutWeight(1)
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.toast('需同意《用户服务协议》与《隐私政策》后才能使用本应用');
            })
          Button('同意并继续')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#FF6B35')
            .layoutWeight(1)
            .height(44)
            .borderRadius(22)
            .onClick(() => {
              this.privacyAgreed = true;
            })
        }
        .width('100%')
        .margin({ top: 2 })
      }
      .width('86%')
      .padding({ top: 24, bottom: 20, left: 20, right: 20 })
      .backgroundColor($r('app.color.c_card_bg'))
      .borderRadius(18)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.c_mask'))
  }

  build() {
    Stack() {
      Column() {
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
        .backgroundColor($r('app.color.c_card_bg'))
        .onChange((index: number) => {
          this.currentTab = index;
        })
      }
      .width('100%')
      .height('100%')

      if (!this.privacyAgreed) {
        this.PrivacyDialog()
      }
    }
    .width('100%')
    .height('100%')
  }
}