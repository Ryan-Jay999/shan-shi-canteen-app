import { router } from '@kit.ArkUI';
import { OrderDish, OrderInfo } from '../common/Model';
import { CartItem, CartManager, Store } from '../common/Store';
import { CommonTopBar, DemoNotice, DishCounter } from '../common/Widgets';

interface CheckGroup {
  windowName: string;
  canteenName: string;
  list: CartItem[];
}

@Entry
@Component
struct CheckoutPage {
  @StorageLink('cart') cart: CartManager = new CartManager();
  @State selectedSlot: number = 0;
  private slots: string[] = ['尽快取餐 · 约 10 分钟', '12:10 取餐', '12:25 取餐', '12:40 取餐'];

  private groupItems(): CheckGroup[] {
    const groups: CheckGroup[] = [];
    this.cart.items.forEach((it: CartItem) => {
      let found: CheckGroup | null = null;
      for (let i = 0; i < groups.length; i++) {
        if (groups[i].windowName === it.windowName) {
          found = groups[i];
          break;
        }
      }
      if (found === null) {
        const g: CheckGroup = { windowName: it.windowName, canteenName: it.canteenName, list: [] };
        g.list.push(it);
        groups.push(g);
      } else {
        found.list.push(it);
      }
    });
    return groups;
  }

  private submitOrder(): void {
    if (this.cart.count() === 0) {
      return;
    }
    const groups = this.groupItems();
    const dishes: OrderDish[] = [];
    this.cart.items.forEach((it: CartItem) => {
      dishes.push({ name: it.name, price: it.price, qty: it.qty });
    });
    const order: OrderInfo = {
      pickupNo: 'A0' + (18 + this.cart.count() * 3).toString(),
      canteenName: groups.length > 0 ? groups[0].canteenName : '',
      windowName: groups.length === 1 ? groups[0].windowName : `${groups.length} 个窗口`,
      slot: this.slots[this.selectedSlot],
      total: this.cart.total(),
      items: dishes,
      finished: false
    };
    AppStorage.setOrCreate('lastOrder', order);
    this.cart.clear();
    router.replaceUrl({ url: 'pages/OrderStatusPage' });
  }

  build() {
    Column() {
      CommonTopBar({ title: '确认订单', showBack: true })

      Scroll() {
        Column({ space: 12 }) {
          DemoNotice({ text: '演示下单：本次下单不会产生真实扣款，也不会真实出餐，取餐号为演示编号。' })

          // 取餐方式
          Column({ space: 10 }) {
            Row() {
              Text('取餐方式')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.c_text_primary'))
                .layoutWeight(1)
              Text('食堂窗口自提 🧍')
                .fontSize(12)
                .fontColor($r('app.color.c_text_secondary'))
            }
            .width('100%')

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.slots, (s: string, idx: number) => {
                Text(s)
                  .fontSize(12)
                  .fontColor(this.selectedSlot === idx ? $r('app.color.c_brand') : $r('app.color.c_text_secondary'))
                  .backgroundColor(this.selectedSlot === idx ? $r('app.color.c_brand_bg') : $r('app.color.c_chip_bg'))
                  .borderRadius(8)
                  .padding({ left: 10, right: 10, top: 7, bottom: 7 })
                  .margin({ right: 8, bottom: 8 })
                  .onClick(() => {
                    this.selectedSlot = idx;
                  })
              }, (s: string) => s)
            }
            .width('100%')
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(12)

          // 按窗口分组的菜品
          ForEach(this.groupItems(), (g: CheckGroup) => {
            Column({ space: 12 }) {
              Row() {
                Text(`🏪 ${g.canteenName}`)
                  .fontSize(12)
                  .fontColor($r('app.color.c_text_tertiary'))
                  .layoutWeight(1)
                Text(g.windowName)
                  .fontSize(13)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.c_text_primary'))
              }
              .width('100%')

              ForEach(g.list, (it: CartItem) => {
                Row() {
                  Column({ space: 3 }) {
                    Text(it.name)
                      .fontSize(14)
                      .fontColor($r('app.color.c_text_primary'))
                    Text(`¥${it.price.toFixed(1)} / 份`)
                      .fontSize(11)
                      .fontColor($r('app.color.c_text_tertiary'))
                  }
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
                  DishCounter({
                    qty: it.qty,
                    onAdd: () => {
                      this.cart.changeQty(it.dishId, 1);
                    },
                    onMinus: () => {
                      this.cart.changeQty(it.dishId, -1);
                    }
                  })
                }
                .width('100%')
              }, (it: CartItem) => it.dishId.toString())
            }
            .width('100%')
            .padding(14)
            .backgroundColor($r('app.color.c_card_bg'))
            .borderRadius(12)
          }, (g: CheckGroup) => g.windowName)

          // 价格明细
          Column({ space: 8 }) {
            Row() {
              Text('餐品合计')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text(`¥${this.cart.total().toFixed(1)}`)
                .fontSize(13)
                .fontColor($r('app.color.c_text_body'))
            }
            Row() {
              Text('打包费')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text('¥0.0')
                .fontSize(13)
                .fontColor($r('app.color.c_text_body'))
            }
            Row() {
              Text('光盘可得积分')
                .fontSize(13)
                .fontColor($r('app.color.c_text_secondary'))
                .layoutWeight(1)
              Text('+20 积分')
                .fontSize(13)
                .fontColor($r('app.color.c_brand_text'))
            }
          }
          .width('100%')
          .padding(14)
          .backgroundColor($r('app.color.c_card_bg'))
          .borderRadius(12)

          Text('🥬 温馨提示：按需点餐，吃完可参与光盘打卡领积分（演示）')
            .fontSize(11)
            .fontColor($r('app.color.c_text_tertiary'))
            .width('100%')
            .margin({ bottom: 8 })
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

      // 底部支付栏
      Row() {
        Column({ space: 2 }) {
          Text(`¥${this.cart.total().toFixed(1)}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.c_danger'))
          Text('演示下单 · 不产生真实扣款')
            .fontSize(11)
            .fontColor($r('app.color.c_text_tertiary'))
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .margin({ left: 16 })

        Button('确认下单')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#FF6B35')
          .height(46)
          .width(150)
          .borderRadius(23)
          .margin({ right: 14 })
          .onClick(() => {
            this.submitOrder();
          })
      }
      .width('100%')
      .height(70)
      .backgroundColor($r('app.color.c_card_bg'))
    }
    .width('100%')
    .height('100%')
  }
}