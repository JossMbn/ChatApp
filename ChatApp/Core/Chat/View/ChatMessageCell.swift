//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 20/08/2023.
//

import SwiftUI

struct ChatMessageCell: View {
    let message: Message
    private var isFromCurrentUser: Bool {
        return message.isFromCurrentUser
    }
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                
                Text(message.messageText)
                    .font(.subheadline)
                    .padding()
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.25, alignment: .trailing)
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    CircularProfileImageView(user: message.user, imageSize: .xxSmall)
                    
                    Text(message.messageText)
                        .font(.subheadline)
                        .padding()
                        .background(Color("LightDarkGrayColor"))
                        .foregroundColor(Color("WhiteBlackColor"))
                        .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.25, alignment: .leading)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    ChatMessageCell(message: Message.MOCK_MESSAGE)
}
