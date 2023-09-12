import Foundation
import SwiftUI

extension MovieHomePage {
  struct SearchResultMoviesComponenet {
    let viewState: ViewState
  }
}

extension MovieHomePage.SearchResultMoviesComponenet {
  private func lineColor(_ voteAverage: Double) -> Color {
    if voteAverage >= 0.75 {
      return .green
    } else if voteAverage >= 0.50 {
      return .yellow
    } else {
      return .red
    }
  }
}

extension MovieHomePage.SearchResultMoviesComponenet: View {
  var body: some View {
    
    // 검색 했을때 맞는 키워드가 없으면 keywords에는 header만 나오고, Result 부분은 "No results" 가 나오도록 해야됌 (아직 구현 x)
    ScrollView {
      LazyVStack(alignment: .leading) {
        
        Group {
          Spacer(minLength: 20)
          
          Section(
            header:
              VStack(alignment: .leading, spacing: 2) {
                Text("Keywords")
                  .font(.subheadline)
                  .fontWeight(.semibold)
                  .foregroundColor(Color.gray) }) {
                ForEach(viewState.keywordList, id: \.self) { keyword in
                  Divider()
                  HStack {
                    Text(keyword)
                      .font(.subheadline)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                      .resizable()
                      .frame(width: 8, height: 8)
                      .foregroundColor(Color(.gray))
                      .padding(.trailing, 16)
                  }
                }
                    Divider()
              }
        }
        
        Group {
          Spacer(minLength: 20)
          
          Section(
            header:
              VStack(alignment: .leading, spacing: 2) {
                Text("Results for 키워드에 입력한 것이 나오도록")
                  .font(.subheadline)
                  .fontWeight(.semibold)
                  .foregroundColor(Color.gray)
                
                Divider() }) {
            ForEach(viewState.itemList) { item  in
              HStack(spacing: 16) {
                Asset.spongeBob.swiftUIImage
                  .resizable()
                  .frame(width: 100, height: 140)
                  .clipShape(RoundedRectangle(cornerRadius: 10))
                  .overlay(
                    RoundedRectangle(cornerRadius: 10)
                      .stroke(.black, lineWidth: 1)
                  )
                  .shadow(radius: 10)
                
                VStack (alignment: .leading, spacing: 8){
                  Text(item.title)
                    .font(.headline)
                    .foregroundColor( Color(red: 0.85, green: 0.75, blue: 0.05))
                  
                  HStack {
                    Circle()
                      .trim(from: 0, to: 0.75)
                      .stroke(
                        
                        style: StrokeStyle(lineWidth: 2, dash: [1, 1.5]))
                      .rotationEffect(.degrees(-90))
                      .frame(width: 40, height: 40)
                      .foregroundColor(lineColor(item.voteAverage))
                      .shadow(color: lineColor(item.voteAverage), radius: 5, x: 0, y: 0)
                      .overlay (
                        Text("\(Int(item.voteAverage * 100))%")
                          .font(.system(size: 10))
                      )
                    
                    Text(item.releaseDate)
                      .font(.subheadline)
                  }
                  
                  Text(item.overView)
                    .font(.body)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                  .resizable()
                  .frame(width: 8, height: 12)
                  .foregroundColor(Color(.gray))
                  .padding(.trailing, 16)
              } // Hstack
              .padding(.vertical, 8)
              
              Divider()
                .padding(.leading, 144)
            }
          }
        }
      }
    }
  }
}


extension MovieHomePage.SearchResultMoviesComponenet {
  struct ViewState: Equatable {
    let itemList: [MovieItem]
    let keywordList: [String]
  }
}

extension MovieHomePage.SearchResultMoviesComponenet.ViewState {
  struct MovieItem: Equatable, Identifiable {
    let id = UUID()
    let title: String
    let voteAverage: Double
    let releaseDate: String
    let overView: String
  }
}
