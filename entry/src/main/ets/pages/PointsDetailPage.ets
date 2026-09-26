import { PointRecord } from '../common/Model';
import { CommonTopBar } from '../common/Widgets';
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
          .fontColor('#B45309')
          .margin({ top: 22 })
        Text('当前可用积分')
          .fontSize(12)
          .fontColor('#A36534')
        Text('💡 100 积分可兑换 5 元食堂优惠券')
          .fontSize(11)
          .fontColor('#A36534')
          .margin({ top: 10 })
      }
      .width('100%')
      .padding({ bottom: 24 })
      .backgroundColor('#FFF7E6')

      Scroll() {
        Column({ space: 10 }) {
          Text('积分记录')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#666666')
            .width('100%')
            .margin({ top: 14 })

          ForEach(this.records, (r: PointRecord) => {
            Row() {
              Column({ space: 3 }) {
                Text(r.title)
                  .fontSize(14)
                  .fontColor('#222222')
                Text(r.time)
                  .fontSize(11)
                  .fontColor('#AAAAAA')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              Text(`+${r.points}`)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#2BB673')
            }
            .width('100%')
            .padding(14)
            .backgroundColor(Color.White)
            .borderRadius(12)
          }, (r: PointRecord) => r.id.toString())
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .backgroundColor('#F5F6F8')
    }
    .width('100%')
    .height('100%')
  }
}
