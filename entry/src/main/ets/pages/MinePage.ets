import { router } from '@kit.ArkUI';
import { COUPONS, Coupon, OrderInfo } from '../common/Model';
import { Store } from '../common/Store';

interface MineRow {
  icon: string;
  title: string;
  value: string;
}

@Component
export struct MinePage {
  @StorageLink('points') points: number = 0;
  @StorageLink('streak') streak: number = 5;
  @StorageLink('lastOrder') order: OrderInfo | null = null;
  private rows: MineRow[] = [
    { icon: '💳', title: '校园卡', value: '余额 ¥86.50' },
    { icon: '📍', title: '常用地址', value: '梅园 3 号楼' },
    { icon: '🌶️', title: '口味偏好', value: '微辣 · 少油' },
    { icon: '🎧', title: '联系客服', value: '' },
    { icon: '⚙️', title: '设置', value: '' }
  ];

  aboutToAppear(): void {
    Store.init();
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
              .backgroundColor(Color.White)
              .borderRadius(29)
            Column({ space: 4 }) {
              Text('张同学')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('星河大学 · 计算机学院 · 已认证')
                .fontSize(11)
                .fontColor('#FFE8DD')
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
                .fontColor('#222222')
              Text('节约积分')
                .fontSize(11)
                .fontColor('#888888')
            }
            .layoutWeight(1)
            Column({ space: 3 }) {
              Text(COUPONS.length.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#222222')
              Text('优惠券')
                .fontSize(11)
                .fontColor('#888888')
            }
            .layoutWeight(1)
            Column({ space: 3 }) {
              Text(this.streak.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#222222')
              Text('连续光盘(天)')
                .fontSize(11)
                .fontColor('#888888')
            }
            .layoutWeight(1)
          }
          .width('100%')
          .padding({ top: 14, bottom: 14 })
          .backgroundColor(Color.White)
          .borderRadius(14)
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
        .linearGradient({ angle: 140, colors: [['#FF9A6E', 0.0], ['#FF6B35', 1.0]] })

        Column({ space: 14 }) {
          // 最近订单
          Column({ space: 10 }) {
            Row() {
              Text('最近订单')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#222222')
                .layoutWeight(1)
              if (this.order !== null) {
                Text('全部 ›')
                  .fontSize(12)
                  .fontColor('#999999')
              }
            }
            .width('100%')

            if (this.order === null) {
              Text('还没有订单，去点一餐试试吧 🍚')
                .fontSize(12)
                .fontColor('#999999')
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
                    .fontColor('#222222')
                  Text(this.order.finished ? '订单已完成 · 感谢光盘' : `取餐号 ${this.order.pickupNo} · 待取餐`)
                    .fontSize(11)
                    .fontColor('#999999')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Text(`¥${this.order.total.toFixed(1)}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#F04E4E')
              }
              .width('100%')
              .onClick(() => {
                router.pushUrl({ url: 'pages/OrderStatusPage' });
              })
            }
          }
          .width('100%')
          .padding(14)
          .backgroundColor(Color.White)
          .borderRadius(14)

          // 优惠券
          Column({ space: 10 }) {
            Text('积分兑换的优惠券')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222222')
              .width('100%')
            Scroll() {
              Row({ space: 10 }) {
                ForEach(COUPONS, (c: Coupon) => {
                  Column({ space: 4 }) {
                    Text(`¥${c.amount}`)
                      .fontSize(22)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#F04E4E')
                    Text(`满 ${c.threshold} 可用`)
                      .fontSize(10)
                      .fontColor('#F04E4E')
                    Text(c.title)
                      .fontSize(12)
                      .fontColor('#333333')
                      .margin({ top: 2 })
                    Text(c.expire)
                      .fontSize(9)
                      .fontColor('#AAAAAA')
                  }
                  .width(108)
                  .padding({ top: 10, bottom: 10 })
                  .backgroundColor('#FFF4F2')
                  .borderRadius(10)
                }, (c: Coupon) => c.id.toString())
              }
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
          }
          .width('100%')
          .padding(14)
          .backgroundColor(Color.White)
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
                  .fontColor('#333333')
                  .layoutWeight(1)
                if (r.value.length > 0) {
                  Text(r.value)
                    .fontSize(12)
                    .fontColor('#999999')
                    .margin({ right: 4 })
                }
                Text('›')
                  .fontSize(16)
                  .fontColor('#CCCCCC')
              }
              .width('100%')
              .height(50)
              .border(idx === this.rows.length - 1 ? {} : { width: { bottom: 1 }, color: '#F2F2F2' })
            }, (r: MineRow) => r.title)
          }
          .width('100%')
          .padding({ left: 14, right: 14 })
          .backgroundColor(Color.White)
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
    .backgroundColor('#F5F6F8')
  }
}
