import { router } from '@kit.ArkUI';
import { CANTEENS, Canteen, OrderInfo, WindowInfo } from '../common/Model';
import { DemoNotice, LevelTag, SectionTitle } from '../common/Widgets';
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
          .fontColor($r('app.color.c_text_primary'))
          .width('100%')
          .margin({ top: 48 })
        Text('演示点餐流程 · 数据为演示数据')
          .fontSize(12)
          .fontColor($r('app.color.c_text_tertiary'))
          .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })
      .backgroundColor($r('app.color.c_card_bg'))

      Scroll() {
        Column({ space: 14 }) {
          DemoNotice({ text: '演示版：以下食堂、窗口、菜品、价格与排队人数均为演示数据，不接入真实校园系统，' +
            '下单不会产生真实扣款与出餐。' })

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
                    .fontColor($r('app.color.c_warm_text'))
                }
                Text(`${this.order.canteenName} · ${this.order.windowName} · ${this.order.slot}（演示）`)
                  .fontSize(12)
                  .fontColor($r('app.color.c_warm_subtext'))
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('查看取餐码 ›')
                .fontSize(12)
                .fontColor($r('app.color.c_brand'))
            }
            .width('100%')
            .padding(14)
            .backgroundColor($r('app.color.c_warm_bg3'))
            .borderRadius(12)
            .onClick(() => {
              router.pushUrl({ url: 'pages/OrderStatusPage' });
            })
          }

          SectionTitle({ text: '选择食堂', extra: '演示数据' })

          ForEach(CANTEENS, (c: Canteen) => {
            this.CanteenRow(c);
          }, (c: Canteen) => c.id.toString())

          Column({ space: 6 }) {
            Text('🛎️')
              .fontSize(26)
            Text('演示：所有窗口支持线上下单、到点自取')
              .fontSize(12)
              .fontColor($r('app.color.c_text_tertiary'))
          }
          .width('100%')
          .padding({ top: 16, bottom: 24 })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .linearGradient({
        angle: 165,
        colors: [[$r('app.color.c_grad_order1'), 0.0], [$r('app.color.c_grad_order2'), 0.55],
          [$r('app.color.c_grad_order3'), 1.0]]
      })
      .backgroundImage($r('app.media.bg_food_doodle'), ImageRepeat.XY)
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
            .fontColor($r('app.color.c_text_primary'))
          Row({ space: 10 }) {
            Text(c.distance)
              .fontSize(11)
              .fontColor($r('app.color.c_text_tertiary'))
            Text(`${c.windows.length} 个窗口`)
              .fontSize(11)
              .fontColor($r('app.color.c_text_tertiary'))
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
            .fontColor($r('app.color.c_text_secondary'))
            .backgroundColor($r('app.color.c_chip_bg'))
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(8)
            .margin({ right: 6 })
        }, (w: WindowInfo) => w.id.toString())
      }
      .width('100%')

      Button('进入点餐')
        .fontSize(13)
        .fontColor($r('app.color.c_brand'))
        .backgroundColor($r('app.color.c_brand_bg'))
        .width('100%')
        .height(36)
        .borderRadius(18)
        .onClick(() => {
          router.pushUrl({ url: 'pages/CanteenDetailPage', params: { canteenId: c.id } });
        })
    }
    .width('100%')
    .padding(14)
    .backgroundColor($r('app.color.c_card_bg'))
    .borderRadius(14)
  }
}