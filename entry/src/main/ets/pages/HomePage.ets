import { router } from '@kit.ArkUI';
import {
  BarPoint,
  CANTEENS,
  Canteen,
  PEAK_BARS,
  levelColor
} from '../common/Model';
import { LevelTag, SectionTitle } from '../common/Widgets';
import { Store } from '../common/Store';

@Component
export struct HomePage {
  @StorageLink('points') points: number = 0;

  aboutToAppear(): void {
    Store.init();
  }

  build() {
    Column() {
      // 顶部区域
      Column() {
        Row() {
          Column() {
            Text('你好，任同学 👋')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text('今天也要好好吃饭，拒绝浪费')
              .fontSize(12)
              .fontColor('#FFE8DD')
              .margin({ top: 6 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Row() {
            Text('🥇')
              .fontSize(14)
            Text(` ${this.points} 积分`)
              .fontSize(13)
              .fontColor('#B45309')
              .fontWeight(FontWeight.Medium)
          }
          .backgroundColor('#FFF7E6')
          .padding({ left: 10, right: 10, top: 6, bottom: 6 })
          .borderRadius(14)
          .onClick(() => {
            router.pushUrl({ url: 'pages/PointsDetailPage' });
          })
        }
        .width('100%')
        .margin({ top: 14 })

        // 避峰建议横幅
        Row() {
          Text('💡')
            .fontSize(22)
          Column() {
            Text('当前临近午高峰，建议错峰')
              .fontSize(14)
              .fontColor('#7A3B12')
              .fontWeight(FontWeight.Medium)
            Text('12:30 后到校可少排队约 15 分钟，错峰还能领 5 积分')
              .fontSize(11)
              .fontColor('#A36534')
              .margin({ top: 3 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .margin({ left: 10 })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFF3E0')
        .borderRadius(12)
        .margin({ top: 14 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 48, bottom: 18 })
      .linearGradient({ angle: 140, colors: [['#FF9A6E', 0.0], ['#FF6B35', 1.0]] })

      Scroll() {
        Column({ space: 16 }) {
          // 食堂拥挤度
          Column({ space: 10 }) {
            SectionTitle({ text: '食堂实时拥挤度', extra: '每 1 分钟更新' })
            ForEach(CANTEENS, (c: Canteen) => {
              this.CanteenCard(c);
            }, (c: Canteen) => c.id.toString())
          }
          .width('100%')

          // 错峰曲线
          Column({ space: 12 }) {
            SectionTitle({ text: '今日错峰曲线', extra: '第一食堂' })
            Row() {
              ForEach(PEAK_BARS, (b: BarPoint) => {
                Column() {
                  Text(b.now ? '高峰' : '')
                    .fontSize(9)
                    .fontColor('#FF6B35')
                    .height(14)
                  Column()
                    .width(18)
                    .height(b.value * 1.4)
                    .borderRadius(6)
                    .backgroundColor(b.now ? '#FF6B35' : '#FFD2BC')
                  Text(b.time)
                    .fontSize(10)
                    .fontColor(b.now ? '#FF6B35' : '#999999')
                    .margin({ top: 6 })
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.End)
              }, (b: BarPoint) => b.time)
            }
            .width('100%')
            .height(190)
            .alignItems(VerticalAlign.Bottom)
            .padding({ top: 8, bottom: 4, left: 6, right: 6 })
            .backgroundColor('#FAFAFA')
            .borderRadius(12)
          }
          .width('100%')

          // 推荐窗口
          Column({ space: 10 }) {
            SectionTitle({ text: '现在去最划算', extra: '排队短 · 好评多' })
            Scroll() {
              Row({ space: 10 }) {
                ForEach(CANTEENS, (c: Canteen) => {
                  this.WindowCard(c);
                }, (c: Canteen) => 'w' + c.id.toString())
              }
            }
            .scrollable(ScrollDirection.Horizontal)
            .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
            .scrollBar(BarState.Off)
          }
          .width('100%')
          .margin({ bottom: 12 })
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .backgroundColor('#F5F6F8')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CanteenCard(c: Canteen) {
    Row() {
      Column({ space: 6 }) {
        Text(c.name)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222')
        Row({ space: 10 }) {
          Text(c.distance)
            .fontSize(11)
            .fontColor('#888888')
          Text('营业 ' + c.openTime)
            .fontSize(11)
            .fontColor('#888888')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Column({ space: 6 }) {
        LevelTag({ level: c.level })
        Text(`约等待 ${c.wait} 分钟`)
          .fontSize(11)
          .fontColor(levelColor(c.level))
      }
      .alignItems(HorizontalAlign.End)

      Text('点餐 ›')
        .fontSize(12)
        .fontColor(Color.White)
        .backgroundColor('#FF6B35')
        .padding({ left: 12, right: 12, top: 7, bottom: 7 })
        .borderRadius(16)
        .margin({ left: 12 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/CanteenDetailPage', params: { canteenId: c.id } });
        })
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(14)
  }

  @Builder
  WindowCard(c: Canteen) {
    Column({ space: 6 }) {
      Text(c.id === 1 ? '🍜' : (c.id === 2 ? '🥗' : '🍢'))
        .fontSize(30)
      Text(c.name.split(' · ')[1] ?? c.name)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor('#222222')
      Text(`${c.windows[0].queue} 人排队 · ${c.windows[0].dishes[0].name}`)
        .fontSize(10)
        .fontColor('#999999')
        .maxLines(1)
    }
    .width(150)
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => {
      router.pushUrl({ url: 'pages/CanteenDetailPage', params: { canteenId: c.id } });
    })
  }
}
