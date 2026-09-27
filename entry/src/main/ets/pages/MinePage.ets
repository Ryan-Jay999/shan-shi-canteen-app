import { router } from '@kit.ArkUI';
import { COUPONS, Coupon, OrderInfo } from '../common/Model';
import { Store } from '../common/Store';
import { DemoBadge, DemoNotice } from '../common/Widgets';

interface MineRow {
  icon: string;
  title: string;
  editable: boolean;
  route: string;
}

@Component
export struct MinePage {
  @StorageLink('points') points: number = 0;
  @StorageLink('streak') streak: number = 5;
  @StorageLink('lastOrder') order: OrderInfo | null = null;
  @StorageLink('cardValue') cardValue: string = '¥86.50';
  @StorageLink('address') address: string = '梅园 3 号楼';
  @StorageLink('taste') taste: string = '微辣 · 少油';
  private rows: MineRow[] = [
    { icon: '💳', title: '校园卡', editable: true, route: '' },
    { icon: '📍', title: '常用地址', editable: true, route: '' },
    { icon: '🌶️', title: '口味偏好', editable: true, route: '' },
    { icon: '🎧', title: '联系客服', editable: false, route: 'pages/SupportPage' },
    { icon: '⚙️', title: '设置', editable: false, route: 'pages/SettingsPage' }
  ];

  aboutToAppear(): void {
    Store.init();
  }

  private toast(msg: string): void {
    this.getUIContext().getPromptAction().showToast({ message: msg });
  }

  private rowValueOf(title: string): string {
    if (title === '校园卡') {
      return this.cardValue;
    }
    if (title === '常用地址') {
      return this.address;
    }
    if (title === '口味偏好') {
      return this.taste;
    }
    return '';
  }

  private setRowValue(title: string, value: string): void {
    if (title === '校园卡') {
      this.cardValue = value;
    } else if (title === '常用地址') {
      this.address = value;
    } else if (title === '口味偏好') {
      this.taste = value;
    }
  }

  build() {
    Scroll() {
      Column({ space: 14 }) {
        // 个人头部
        Column({ space: 14 }) {
          Row({ space: 12 }) {
            Text('🧑‍🎓')
              .fontSize(30)
              .width(58)
              .height(58)
              .textAlign(TextAlign.Center)
              .backgroundColor($r('app.color.c_card_bg'))
              .borderRadius(29)
            Column({ space: 4 }) {
              Text('任梦强同学')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('上海杉达学院 · 计算与智能技术学院')
                .fontSize(11)
                .fontColor($r('app.color.c_on_brand_sub'))
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .width('100%')
          .margin({ top: 52 })

          Row() {
            Column({ space: 3 }) {
              Text(this.points.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
              Text('节约积分')
                .fontSize(11)
                .fontColor($r('app.color.c_text_tertiary'))
            }
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/PointsDetailPage' });
            })
            Column({ space: 3 }) {
              Text(COUPONS.length.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
              Text('优惠券')
                .fontSize(11)
                .fontColor($r('app.color.c_text_tertiary'))
            }
            .layoutWeight(1)
            .onClick(() => {
              this.toast(`共 ${COUPONS.length} 张优惠券，见下方列表（演示数据）`);
            })
            Column({ space: 3 }) {
              Text(this.streak.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
              Text('连续光盘(天)')
                .fontSize(11)
                .fontColor($r('app.color.c_text_tertiary'))
            }
            .layoutWeight(1)
            .onClick(() => {
              AppStorage.setOrCreate('mainTabIndex', 2);
            })
          }
          .width('100%')
          .padding({ top: 14, bottom: 14 })
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(14)
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
        .linearGradient({ angle: 140, colors: [['#FF9A6E', 0.0], ['#FF6B35', 1.0]] })

        Column({ space: 14 }) {
          DemoNotice({ text: '本应用为演示版本。以下积分、优惠券、订单与个人资料均为演示内容，仅保存在本机。' })

          // 最近订单
          Column({ space: 10 }) {
            Row({ space: 8 }) {
              Text('最近订单')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
              DemoBadge()
              Blank()
              if (this.order !== null) {
                Text('全部 ›')
                  .fontSize(12)
                  .fontColor($r('app.color.c_text_tertiary'))
              }
            }
            .width('100%')

            if (this.order === null) {
              Text('还没有订单，去点一餐试试吧 🍚')
                .fontSize(12)
                .fontColor($r('app.color.c_text_tertiary'))
                .width('100%')
                .padding({ top: 6, bottom: 6 })
            } else {
              Row() {
                Text(this.order.finished ? '✅' : '🔔')
                  .fontSize(20)
                  .margin({ right: 10 })
                Column({ space: 3 }) {
                  Text(`${this.order.canteenName} · ${this.order.windowName}`)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('app.color.c_text_primary'))
                  Text(this.order.finished ? '订单已完成 · 感谢光盘' : `取餐号 ${this.order.pickupNo} · 待取餐`)
                    .fontSize(11)
                    .fontColor($r('app.color.c_text_tertiary'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Text(`¥${this.order.total.toFixed(1)}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.c_danger'))
              }
              .width('100%')
              .onClick(() => {
                router.pushUrl({ url: 'pages/OrderStatusPage' });
              })
            }
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(14)

          // 优惠券
          Column({ space: 10 }) {
            Row({ space: 8 }) {
              Text('积分兑换的优惠券')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
              DemoBadge()
            }
            .width('100%')
            Scroll() {
              Row({ space: 10 }) {
                ForEach(COUPONS, (c: Coupon) => {
                  Column({ space: 4 }) {
                    Text(`¥${c.amount}`)
                      .fontSize(22)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.c_danger'))
                    Text(`满 ${c.threshold} 可用`)
                      .fontSize(10)
                      .fontColor($r('app.color.c_danger'))
                    Text(c.title)
                      .fontSize(12)
                      .fontColor($r('app.color.c_text_body'))
                      .margin({ top: 2 })
                    Text(c.expire)
                      .fontSize(9)
                      .fontColor($r('app.color.c_text_weak'))
                  }
                  .width(108)
                  .padding({ top: 10, bottom: 10 })
                  .backgroundColor($r('app.color.c_brand_bg'))
                  .borderRadius(10)
                }, (c: Coupon) => c.id.toString())
              }
            }
            .scrollable(ScrollDirection.Horizontal)
            .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
            .scrollBar(BarState.Off)
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(14)

          // 功能列表
          Column() {
            ForEach(this.rows, (r: MineRow, idx: number) => {
              Row() {
                Text(r.icon)
                  .fontSize(18)
                  .width(30)
                Text(r.title)
                  .fontSize(14)
                  .fontColor($r('app.color.c_text_body'))
                  .layoutWeight(1)
                if (r.editable) {
                  TextInput({ text: this.rowValueOf(r.title) })
                    .fontSize(12)
                    .fontColor($r('app.color.c_text_secondary'))
                    .textAlign(TextAlign.End)
                    .width(130)
                    .padding(0)
                    .backgroundColor(Color.Transparent)
                    .onChange((v: string) => {
                      this.setRowValue(r.title, v);
                    })
                  Text('✎')
                    .fontSize(13)
                    .fontColor($r('app.color.c_brand'))
                    .margin({ left: 4 })
                } else {
                  Text('›')
                    .fontSize(16)
                    .fontColor($r('app.color.c_text_tertiary'))
                }
              }
              .width('100%')
              .height(50)
              .onClick(() => {
                if (r.route.length > 0) {
                  router.pushUrl({ url: r.route });
                }
              })
              .border(idx === this.rows.length - 1 ? {} : { width: { bottom: 1 }, color: $r('app.color.c_divider') })
            }, (r: MineRow) => r.title)
          }
          .width('100%')
          .padding({ left: 14, right: 14 })
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(14)
          .margin({ bottom: 12 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .backgroundColor($r('app.color.c_page_bg'))
  }
}