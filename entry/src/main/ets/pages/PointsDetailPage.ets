import { PointRecord } from '../common/Model';
import { CommonTopBar, DemoNotice } from '../common/Widgets';
import { Store } from '../common/Store';

@Entry
@Component
struct PointsDetailPage {
  @StorageLink('points') points: number = 0;
  @StorageLink('records') records: PointRecord[] = [];

  aboutToAppear(): void {
    Store.init();
  }

  build() {
    Column() {
      CommonTopBar({ title: '积分明细', showBack: true })

      Column({ space: 4 }) {
        Text(this.points.toString())
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.c_brand_text'))
          .margin({ top: 22 })
        Text('当前可用积分（演示数据）')
          .fontSize(12)
          .fontColor($r('app.color.c_warm_subtext'))
        Text('💡 演示：100 积分可兑换 5 元食堂优惠券，仅用于展示兑换机制的交互效果')
          .fontSize(11)
          .fontColor($r('app.color.c_warm_subtext'))
          .margin({ top: 10 })
          .padding({ left: 16, right: 16 })
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ bottom: 24 })
      .backgroundColor($r('app.color.c_warm_bg'))

      Scroll() {
        Column({ space: 10 }) {
          DemoNotice({ text: '演示数据：积分与积分记录均保存在本机，不接入真实校园系统，不可用于真实消费。' })

          Text('积分记录')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.c_text_secondary'))
            .width('100%')
            .margin({ top: 4 })

          if (this.records.length === 0) {
            Column({ space: 6 }) {
              Text('📭')
                .fontSize(36)
              Text('暂无积分记录')
                .fontSize(13)
                .fontColor($r('app.color.c_text_tertiary'))
            }
            .width('100%')
            .padding({ top: 40, bottom: 40 })
            .backgroundColor($r('app.color.c_card_bg'))
            .borderRadius(12)
          } else {
            ForEach(this.records, (r: PointRecord) => {
              Row() {
                Column({ space: 3 }) {
                  Text(r.title)
                    .fontSize(14)
                    .fontColor($r('app.color.c_text_primary'))
                  Text(r.time)
                    .fontSize(11)
                    .fontColor($r('app.color.c_text_weak'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Text(`+${r.points}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.c_success'))
              }
              .width('100%')
              .padding(14)
              .backgroundColor($r('app.color.c_card_bg'))
              .borderRadius(12)
            }, (r: PointRecord) => r.id.toString())
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .backgroundColor($r('app.color.c_page_bg'))
    }
    .width('100%')
    .height('100%')
  }
}