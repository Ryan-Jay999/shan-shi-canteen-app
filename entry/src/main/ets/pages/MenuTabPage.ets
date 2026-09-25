import { router } from '@kit.ArkUI';
import { CANTEENS, Canteen, OrderInfo, WindowInfo } from '../common/Model';
import { LevelTag, SectionTitle } from '../common/Widgets';
import { Store } from '../common/Store';

@Component
export struct MenuTabPage {
  @StorageLink('lastOrder') order: OrderInfo | null = null;

  aboutToAppear(): void {
    Store.init();
  }

  build() {
    Column() {
      // 标题栏
      Column({ space: 2 }) {
        Text('在线点餐')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222')
          .width('100%')
          .margin({ top: 48 })
        Text('提前点单不排队，到点即取')
          .fontSize(12)
          .fontColor('#999999')
          .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })
      .backgroundColor(Color.White)

      Scroll() {
        Column({ space: 14 }) {
          // 进行中的订单
          if (this.order !== null && !this.order.finished) {
            Row() {
              Column({ space: 5 }) {
                Row({ space: 8 }) {
                  Text('🔔')
                    .fontSize(16)
                  Text(`取餐号 ${this.order.pickupNo}`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#7A3B12')
                }
                Text(`${this.order.canteenName} · ${this.order.windowName} · ${this.order.slot}`)
                  .fontSize(12)
                  .fontColor('#A36534')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('查看取餐码 ›')
                .fontSize(12)
                .fontColor('#FF6B35')
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#FFF3E8')
            .borderRadius(12)
            .onClick(() => {
              router.pushUrl({ url: 'pages/OrderStatusPage' });
            })
          }

          SectionTitle({ text: '选择食堂' })

          ForEach(CANTEENS, (c: Canteen) => {
            this.CanteenRow(c);
          }, (c: Canteen) => c.id.toString())

          Column({ space: 6 }) {
            Text('🛎️')
              .fontSize(26)
            Text('所有窗口支持线上下单、到点自取')
              .fontSize(12)
              .fontColor('#999999')
          }
          .width('100%')
          .padding({ top: 16, bottom: 24 })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#F5F6F8')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CanteenRow(c: Canteen) {
    Column({ space: 12 }) {
      Row() {
        Column({ space: 5 }) {
          Text(c.name)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#222222')
          Row({ space: 10 }) {
            Text(c.distance)
              .fontSize(11)
              .fontColor('#888888')
            Text(`${c.windows.length} 个窗口`)
              .fontSize(11)
              .fontColor('#888888')
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        LevelTag({ level: c.level })
      }
      .width('100%')

      // 窗口速览
      Row() {
        ForEach(c.windows, (w: WindowInfo) => {
          Text(w.name)
            .fontSize(11)
            .fontColor('#666666')
            .backgroundColor('#F2F3F5')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(8)
            .margin({ right: 6 })
        }, (w: WindowInfo) => w.id.toString())
      }
      .width('100%')

      Button('进入点餐')
        .fontSize(13)
        .fontColor('#FF6B35')
        .backgroundColor('#FFF0E8')
        .width('100%')
        .height(36)
        .borderRadius(18)
        .onClick(() => {
          router.pushUrl({ url: 'pages/CanteenDetailPage', params: { canteenId: c.id } });
        })
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(14)
  }
}
