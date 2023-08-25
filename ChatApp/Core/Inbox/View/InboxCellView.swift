//
//  InboxCellView.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import SwiftUI

struct InboxCellView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            CircularProfileImageView(user: message.user, imageSize: .medium)
            VStack(spacing: 4) {
                HStack {
                    Text(message.user?.fullname ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(message.messageTimestampString)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                }
                Text(message.messageText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(height: 72)
    }
}

struct InboxCellView_Previews: PreviewProvider {
    static var previews: some View {
        InboxCellView(message: Message.MOCK_MESSAGE)
    }
}
