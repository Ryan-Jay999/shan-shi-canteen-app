import { router } from '@kit.ArkUI';
import { CrowdLevel, levelBg, levelColor, levelText } from './Model';

// 拥挤程度小标签
@Component
export struct LevelTag {
  @Prop level: CrowdLevel = CrowdLevel.Free;

  build() {
    Text(levelText(this.level))
      .fontSize(11)
      .fontColor(levelColor(this.level))
      .backgroundColor(levelBg(this.level))
      .padding({ left: 8, right: 8, top: 3, bottom: 3 })
      .borderRadius(6)
  }
}

// 菜品数量加减控件
@Component
export struct DishCounter {
  @Prop qty: number = 0;
  onAdd: () => void = () => {};
  onMinus: () => void = () => {};

  build() {
    Row() {
      if (this.qty > 0) {
        Button('−')
          .fontSize(16)
          .fontColor($r('app.color.c_brand'))
          .backgroundColor($r('app.color.c_brand_bg'))
          .width(26)
          .height(26)
          .borderRadius(13)
          .padding(0)
          .onClick(() => {
            this.onMinus();
          })
        Text(this.qty.toString())
          .fontSize(14)
          .fontColor($r('app.color.c_text_body'))
          .width(28)
          .textAlign(TextAlign.Center)
      }
      Button('+')
        .fontSize(16)
        .fontColor(Color.White)
        .backgroundColor('#FF6B35')
        .width(26)
        .height(26)
        .borderRadius(13)
        .padding(0)
        .onClick(() => {
          this.onAdd();
        })
    }
  }
}

// 二级页通用导航栏
@Component
export struct CommonTopBar {
  @Prop title: string = '';
  showBack: boolean = true;

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Text(this.title)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.c_text_primary'))
        .width('100%')
        .textAlign(TextAlign.Center)
      if (this.showBack) {
        Text('‹')
          .fontSize(30)
          .fontColor($r('app.color.c_text_body'))
          .margin({ left: 12 })
          .onClick(() => {
            router.back();
          })
      }
    }
    .width('100%')
    .height(48)
    .backgroundColor($r('app.color.c_card_bg'))
  }
}

// 分组小标题
@Component
export struct SectionTitle {
  @Prop text: string = '';
  @Prop extra: string = '';

  build() {
    Row() {
      Text(this.text)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.c_text_primary'))
      Blank()
      if (this.extra.length > 0) {
        Text(this.extra)
          .fontSize(12)
          .fontColor($r('app.color.c_text_tertiary'))
      }
    }
    .width('100%')
  }
}

// 「演示数据」标识
@Component
export struct DemoBadge {
  build() {
    Text('演示数据')
      .fontSize(10)
      .fontColor($r('app.color.c_brand_text'))
      .backgroundColor($r('app.color.c_brand_bg'))
      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
      .borderRadius(6)
  }
}

// 演示版声明横幅
@Component
export struct DemoNotice {
  @Prop text: string = '';

  build() {
    Row({ space: 8 }) {
      Text('ℹ️')
        .fontSize(14)
      Text(this.text)
        .fontSize(11)
        .fontColor($r('app.color.c_warm_text'))
        .layoutWeight(1)
    }
    .width('100%')
    .padding(10)
    .backgroundColor($r('app.color.c_warm_bg'))
    .borderRadius(10)
  }
}