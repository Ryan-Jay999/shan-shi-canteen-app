import { router } from '@kit.ArkUI';
import { OrderDish, OrderInfo } from '../common/Model';

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
        .fontColor(done ? Color.White : '#BBBBBB')
        .backgroundColor(done ? '#FF6B35' : '#EEEEEE')
        .width(26)
        .height(26)
        .borderRadius(13)
        .textAlign(TextAlign.Center)
      Text(label)
        .fontSize(14)
        .fontColor(done ? '#222222' : '#999999')
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
            .fontColor('#999999')
          Text('去点餐')
            .fontSize(14)
            .fontColor('#FF6B35')
            .margin({ top: 8 })
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column({ space: 14 }) {
            // 取餐码卡片
            Column({ space: 10 }) {
              Text('🔔 下单成功，请等待叫号')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#7A3B12')
              Text(this.order.pickupNo)
                .fontSize(56)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FF6B35')
                .margin({ top: 4, bottom: 4 })
              Text(`前方还有 3 单 · 预计 8 分钟可取`)
                .fontSize(13)
                .fontColor('#A36534')
              Text(`${this.order.canteenName} · ${this.order.slot}`)
                .fontSize(12)
                .fontColor('#A36534')
            }
            .width('100%')
            .padding({ top: 24, bottom: 24 })
            .backgroundColor('#FFF3E8')
            .borderRadius(14)

            // 进度
            Column({ space: 16 }) {
              this.Step('1', '商家已接单', true)
              this.Step('2', '正在备餐中', true)
              this.Step('3', '等待取餐', false)
              this.Step('4', '已完成', false)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(14)

            // 订单内容
            Column({ space: 10 }) {
              Text('订单内容')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#222222')
                .width('100%')
              ForEach(this.order.items, (d: OrderDish) => {
                Row() {
                  Text(d.name)
                    .fontSize(13)
                    .fontColor('#333333')
                    .layoutWeight(1)
                  Text(`x${d.qty}`)
                    .fontSize(13)
                    .fontColor('#999999')
                    .margin({ right: 16 })
                  Text(`¥${(d.price * d.qty).toFixed(1)}`)
                    .fontSize(13)
                    .fontColor('#333333')
                }
                .width('100%')
              }, (d: OrderDish) => d.name)
              Row() {
                Text('合计')
                  .fontSize(14)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#222222')
                  .layoutWeight(1)
                Text(`¥${this.order.total.toFixed(1)}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#F04E4E')
              }
              .width('100%')
              .margin({ top: 4 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
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
              Text('✅ 订单已完成，记得光盘打卡领积分')
                .fontSize(13)
                .fontColor('#2BB673')
                .width('100%')
                .textAlign(TextAlign.Center)
            }
          }
          .width('100%')
          .padding(16)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .backgroundColor('#F5F6F8')
      }
    }
    .width('100%')
    .height('100%')
  }
}
