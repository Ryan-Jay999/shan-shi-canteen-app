import { router } from '@kit.ArkUI';
import { Canteen, Dish, WindowInfo, findCanteen } from '../common/Model';
import { CartManager, Store } from '../common/Store';
import { CommonTopBar, DishCounter } from '../common/Widgets';

interface DetailParams {
  canteenId: number;
}

@Entry
@Component
struct CanteenDetailPage {
  @State canteen: Canteen = findCanteen(1);
  @State selectedWindow: number = findCanteen(1).windows[0].id;
  @StorageLink('cart') cart: CartManager = new CartManager();

  aboutToAppear(): void {
    Store.init();
    const p = router.getParams();
    if (p !== null && p !== undefined) {
      const param = p as DetailParams;
      this.canteen = findCanteen(param.canteenId);
      this.selectedWindow = this.canteen.windows[0].id;
    }
  }

  private currentWindow(): WindowInfo {
    for (let i = 0; i < this.canteen.windows.length; i++) {
      if (this.canteen.windows[i].id === this.selectedWindow) {
        return this.canteen.windows[i];
      }
    }
    return this.canteen.windows[0];
  }

  build() {
    Column() {
      CommonTopBar({ title: this.canteen.name, showBack: true })

      // 左窗口 / 右菜品
      Row() {
        // 左侧窗口栏
        Scroll() {
          Column() {
            ForEach(this.canteen.windows, (w: WindowInfo) => {
              Column({ space: 4 }) {
                Text(w.name)
                  .fontSize(13)
                  .fontColor(this.selectedWindow === w.id ? '#FF6B35' : '#555555')
                  .fontWeight(this.selectedWindow === w.id ? FontWeight.Bold : FontWeight.Normal)
                Text(`${w.queue} 人排队`)
                  .fontSize(10)
                  .fontColor(this.selectedWindow === w.id ? '#FFB08A' : '#AAAAAA')
              }
              .width('100%')
              .padding({ top: 16, bottom: 16, left: 6, right: 6 })
              .backgroundColor(this.selectedWindow === w.id ? Color.White : '#F5F6F8')
              .onClick(() => {
                this.selectedWindow = w.id;
              })
            }, (w: WindowInfo) => w.id.toString())
          }
          .width('100%')
        }
        .layoutWeight(2.2)
        .scrollBar(BarState.Off)
        .backgroundColor('#F5F6F8')

        // 右侧菜品
        Scroll() {
          Column({ space: 14 }) {
            Row() {
              Text(this.currentWindow().name)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#222222')
                .layoutWeight(1)
              Text(this.currentWindow().tags)
                .fontSize(11)
                .fontColor('#999999')
            }
            .width('100%')

            ForEach(this.currentWindow().dishes, (d: Dish) => {
              this.DishRow(d);
            }, (d: Dish) => d.id.toString())
          }
          .width('100%')
          .padding(12)
        }
        .layoutWeight(5)
        .scrollBar(BarState.Off)
        .backgroundColor(Color.White)
      }
      .layoutWeight(1)

      // 底部餐车栏
      Row() {
        Stack({ alignContent: Alignment.TopEnd }) {
          Text('🛒')
            .fontSize(26)
            .width(48)
            .height(48)
            .textAlign(TextAlign.Center)
            .backgroundColor(this.cart.count() > 0 ? '#FF6B35' : '#CCCCCC')
            .borderRadius(24)
            .padding({ top: 10 })
          if (this.cart.count() > 0) {
            Text(this.cart.count().toString())
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor('#F04E4E')
              .borderRadius(8)
              .constraintSize({ minWidth: 16 })
              .height(16)
              .textAlign(TextAlign.Center)
              .padding({ left: 3, right: 3 })
          }
        }
        .margin({ left: 14 })

        Column({ space: 2 }) {
          if (this.cart.count() > 0) {
            Text(`¥${this.cart.total().toFixed(1)}`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#222222')
            Text('已点 ' + this.cart.count().toString() + ' 份')
              .fontSize(11)
              .fontColor('#999999')
          } else {
            Text('购物车还是空的')
              .fontSize(14)
              .fontColor('#999999')
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 12 })

        Button('去结算')
          .fontSize(15)
          .fontColor(Color.White)
          .backgroundColor(this.cart.count() > 0 ? '#FF6B35' : '#DDDDDD')
          .height(44)
          .width(110)
          .borderRadius(22)
          .margin({ right: 14 })
          .onClick(() => {
            if (this.cart.count() > 0) {
              router.pushUrl({ url: 'pages/CheckoutPage' });
            }
          })
      }
      .width('100%')
      .height(68)
      .backgroundColor(Color.White)
      .border({ width: { top: 1 }, color: '#F0F0F0' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }

  @Builder
  DishRow(d: Dish) {
    Row({ space: 10 }) {
      Text(d.emoji)
        .fontSize(28)
        .width(56)
        .height(56)
        .textAlign(TextAlign.Center)
        .backgroundColor('#F7F8FA')
        .borderRadius(10)

      Column({ space: 5 }) {
        Text(d.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#222222')
          .maxLines(1)
        Text(d.tags.join(' · '))
          .fontSize(10)
          .fontColor('#FF9A6E')
        Row() {
          Text(`¥${d.price.toFixed(1)}`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F04E4E')
            .layoutWeight(1)
          Text(`月售 ${d.sales}`)
            .fontSize(10)
            .fontColor('#AAAAAA')
        }
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      if (d.soldOut) {
        Text('已售罄')
          .fontSize(11)
          .fontColor('#AAAAAA')
          .backgroundColor('#F2F3F5')
          .padding({ left: 8, right: 8, top: 5, bottom: 5 })
          .borderRadius(10)
      } else {
        DishCounter({
          qty: this.cart.qtyOf(d.id),
          onAdd: () => {
            this.cart.add(d, this.currentWindow().name, this.canteen.name);
          },
          onMinus: () => {
            this.cart.changeQty(d.id, -1);
          }
        })
      }
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }
}
