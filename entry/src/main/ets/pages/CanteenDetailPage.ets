import { router } from '@kit.ArkUI';
import { Canteen, Dish, WindowInfo, findCanteen } from '../common/Model';
import { CartManager, Store } from '../common/Store';
import { CommonTopBar, DemoBadge, DishCounter } from '../common/Widgets';

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
                  .fontColor(this.selectedWindow === w.id ? $r('app.color.c_brand') : $r('app.color.c_text_secondary'))
                  .fontWeight(this.selectedWindow === w.id ? FontWeight.Bold : FontWeight.Normal)
                Text(`${w.queue} 人排队`)
                  .fontSize(10)
                  .fontColor(this.selectedWindow === w.id ? $r('app.color.c_brand_light') : $r('app.color.c_text_tertiary'))
              }
              .width('100%')
              .padding({ top: 16, bottom: 16, left: 6, right: 6 })
              .backgroundColor(this.selectedWindow === w.id ? $r('app.color.c_card_bg') : Color.Transparent)
              .onClick(() => {
                this.selectedWindow = w.id;
              })
            }, (w: WindowInfo) => w.id.toString())
          }
          .width('100%')
        }
        .layoutWeight(2.2)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .linearGradient({
          angle: 165,
          colors: [[$r('app.color.c_grad_left1'), 0.0], [$r('app.color.c_grad_left2'), 0.55],
            [$r('app.color.c_grad_left3'), 1.0]]
        })
        .backgroundImage($r('app.media.bg_food_doodle'), ImageRepeat.XY)

        // 右侧菜品
        Scroll() {
          Column({ space: 14 }) {
            Row({ space: 8 }) {
              Text(this.currentWindow().name)
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.c_text_primary'))
              DemoBadge()
              Blank()
              Text(this.currentWindow().tags)
                .fontSize(11)
                .fontColor($r('app.color.c_text_tertiary'))
            }
            .width('100%')

            ForEach(this.currentWindow().dishes, (d: Dish) => {
              this.DishRow(d);
            }, (d: Dish) => d.id.toString())

            Text('演示数据：菜品、价格与销量均非真实在校数据')
              .fontSize(10)
              .fontColor($r('app.color.c_text_tertiary'))
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 6, bottom: 4 })
          }
          .width('100%')
          .padding(12)
        }
        .layoutWeight(5)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
        .linearGradient({
          angle: 165,
          colors: [[$r('app.color.c_grad_right1'), 0.0], [$r('app.color.c_grad_right2'), 0.55],
            [$r('app.color.c_grad_right3'), 1.0]]
        })
        .backgroundImage($r('app.media.bg_food_doodle'), ImageRepeat.XY)
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
            .backgroundColor(this.cart.count() > 0 ? '#FF6B35' : $r('app.color.c_disabled_icon'))
            .borderRadius(24)
            .padding({ top: 10 })
          if (this.cart.count() > 0) {
            Text(this.cart.count().toString())
              .fontSize(10)
              .fontColor(Color.White)
              .backgroundColor($r('app.color.c_danger'))
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
              .fontColor($r('app.color.c_text_primary'))
            Text('已点 ' + this.cart.count().toString() + ' 份')
              .fontSize(11)
              .fontColor($r('app.color.c_text_tertiary'))
          } else {
            Text('购物车还是空的')
              .fontSize(14)
              .fontColor($r('app.color.c_text_tertiary'))
          }
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 12 })

        Button('去结算')
          .fontSize(15)
          .fontColor(Color.White)
          .backgroundColor(this.cart.count() > 0 ? '#FF6B35' : $r('app.color.c_disabled_bg'))
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
      .backgroundColor($r('app.color.c_card_bg'))
      .border({ width: { top: 1 }, color: $r('app.color.c_divider') })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.c_page_bg'))
  }

  @Builder
  DishRow(d: Dish) {
    Row({ space: 10 }) {
      Text(d.emoji)
        .fontSize(28)
        .width(56)
        .height(56)
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.c_surface_soft'))
        .borderRadius(10)

      Column({ space: 5 }) {
        Text(d.name)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.c_text_primary'))
          .maxLines(1)
        Text(d.tags.join(' · '))
          .fontSize(10)
          .fontColor($r('app.color.c_brand_light'))
        Row() {
          Text(`¥${d.price.toFixed(1)}`)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.c_danger'))
            .layoutWeight(1)
          Text(`月售 ${d.sales}`)
            .fontSize(10)
            .fontColor($r('app.color.c_text_weak'))
        }
        .width('100%')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      if (d.soldOut) {
        Text('已售罄')
          .fontSize(11)
          .fontColor($r('app.color.c_text_weak'))
          .backgroundColor($r('app.color.c_chip_bg'))
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