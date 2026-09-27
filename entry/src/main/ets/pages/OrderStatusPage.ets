import { router } from '@kit.ArkUI';
import { OrderDish, OrderInfo } from '../common/Model';
import { DemoNotice } from '../common/Widgets';

@Entry
@Component
struct OrderStatusPage {
  @StorageLink('lastOrder') order: OrderInfo | null = null;

  private finishAndGoPlate(): void {
    if (this.order !== null) {
      const updated: OrderInfo = {
        pickupNo: this.order.pickupNo,
        canteenName: this.order.canteenName,
        windowName: this.order.windowName,
        slot: this.order.slot,
        total: this.order.total,
        items: this.order.items,
        finished: true
      };
      AppStorage.setOrCreate('lastOrder', updated);
    }
    AppStorage.setOrCreate('mainTabIndex', 2);
    router.back({ url: 'pages/Index' });
  }

  @Builder
  Step(no: string, label: string, done: boolean) {
    Row({ space: 10 }) {
      Text(no)
        .fontSize(12)
        .fontColor(done ? Color.White : $r('app.color.c_disabled_icon'))
        .backgroundColor(done ? '#FF6B35' : $r('app.color.c_disabled_bg2'))
        .width(26)
        .height(26)
        .borderRadius(13)
        .textAlign(TextAlign.Center)
      Text(label)
        .fontSize(14)
        .fontColor(done ? $r('app.color.c_text_primary') : $r('app.color.c_text_tertiary'))
        .fontWeight(done ? FontWeight.Medium : FontWeight.Normal)
    }
  }

  build() {
    Column() {
      if (this.order === null) {
        Column({ space: 10 }) {
          Text('📭')
            .fontSize(40)
          Text('暂无进行中的订单')
            .fontSize(14)
            .fontColor($r('app.color.c_text_tertiary'))
          Text('去点餐')
            .fontSize(14)
            .fontColor($r('app.color.c_brand'))
            .margin({ top: 8 })
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.c_page_bg'))
      } else {
        Scroll() {
          Column({ space: 14 }) {
            // 取餐码卡片
            Column({ space: 10 }) {
              Text('🔔 演示下单成功')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_warm_text'))
              Text(this.order.pickupNo)
                .fontSize(56)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF6B35')
                .margin({ top: 4, bottom: 4 })
              Text('演示：前方还有 3 单 · 预计 8 分钟可取')
                .fontSize(13)
                .fontColor($r('app.color.c_warm_subtext'))
              Text(`${this.order.canteenName} · ${this.order.slot}`)
                .fontSize(12)
                .fontColor($r('app.color.c_warm_subtext'))
              Text('该取餐号与进度均为演示数据，不会真实出餐')
                .fontSize(11)
                .fontColor($r('app.color.c_warm_subtext'))
                .margin({ top: 2 })
            }
            .width('100%')
            .padding({ top: 24, bottom: 24, left: 12, right: 12 })
            .backgroundColor($r('app.color.c_warm_bg3'))
            .borderRadius(14)

            // 进度
            Column({ space: 16 }) {
              this.Step('1', '商家已接单（演示）', true)
              this.Step('2', '正在备餐中（演示）', true)
              this.Step('3', '等待取餐（演示）', false)
              this.Step('4', '已完成（演示）', false)
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.c_card_bg'))
            .borderRadius(14)

            // 订单内容
            Column({ space: 10 }) {
              Text('订单内容')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.c_text_primary'))
                .width('100%')
              ForEach(this.order.items, (d: OrderDish) => {
                Row() {
                  Text(d.name)
                    .fontSize(13)
                    .fontColor($r('app.color.c_text_body'))
                    .layoutWeight(1)
                  Text(`x${d.qty}`)
                    .fontSize(13)
                    .fontColor($r('app.color.c_text_tertiary'))
                    .margin({ right: 16 })
                  Text(`¥${(d.price * d.qty).toFixed(1)}`)
                    .fontSize(13)
                    .fontColor($r('app.color.c_text_body'))
                }
                .width('100%')
              }, (d: OrderDish) => d.name)
              Row() {
                Text('合计')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.c_text_primary'))
                  .layoutWeight(1)
                Text(`¥${this.order.total.toFixed(1)}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.c_danger'))
              }
              .width('100%')
              .margin({ top: 4 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor($r('app.color.c_card_bg'))
            .borderRadius(14)

            if (!this.order.finished) {
              Button('我已取餐，去光盘打卡 🥗')
                .fontSize(16)
                .fontColor(Color.White)
                .backgroundColor('#FF6B35')
                .width('100%')
                .height(48)
                .borderRadius(24)
                .onClick(() => {
                  this.finishAndGoPlate();
                })
            } else {
              Text('✅ 订单已完成（演示），记得光盘打卡领积分')
                .fontSize(13)
                .fontColor($r('app.color.c_success'))
                .width('100%')
                .textAlign(TextAlign.Center)
            }

            DemoNotice({ text: '演示数据：本页订单、取餐号与进度均为演示内容，不会真实出餐，也不产生扣款。' })
          }
          .width('100%')
          .padding(16)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .backgroundColor($r('app.color.c_page_bg'))
      }
    }
    .width('100%')
    .height('100%')
  }
}