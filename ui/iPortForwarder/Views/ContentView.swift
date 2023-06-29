import SwiftUI

struct ContentView: View {
    @State private var items: [ForwardedItem] = [ForwardedItem]()

    @State private var isAddingNew = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(items) { item in
                        ForwardedItemRow(
                            item: item,
                            errors: errorsOfForwardRules[item.id],
                            onChange: { ipAddress, remotePort, localPort, allowLan in
                                let index = items.firstIndex(where: { $0 === item })!
                                items[index].destory()
                                do {
                                    errorsOfForwardRules.removeValue(forKey: item.id)
                                    let newItem = try ForwardedItem(ip: ipAddress, remotePort: remotePort, localPort: localPort, allowLan: allowLan)
                                    withAnimation {
                                        items[index] = newItem
                                    }
                                } catch {
                                    showIpfError(error)
                                }
                            },
                            onDelete: {
                                let index = items.firstIndex(where: { $0 === item })
                                withAnimation {
                                    items.remove(at: index!)
                                    errorsOfForwardRules.removeValue(forKey: item.id)
                                }
                            }
                        )
                        .contextMenu {
                            Button(action: {
                                let index = items.firstIndex(where: { $0 === item })
                                _ = withAnimation {
                                    items.remove(at: index!)
                                }
                            }) {
                                Text("Delete")
                            }
                        }
                    }

                    if isAddingNew {
                        ForwardedItemRow(onNewItemAdded: { newItem in
                            items.append(newItem)
                            isAddingNew = false
                        }, onCancel: { withAnimation {
                            isAddingNew = false
                        } })
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }

                // A hack to make ScrollView stable
                if items.isEmpty {
                    HStack {
                        Spacer()
                    }
                }
            }
            .frame(minWidth: 400, minHeight: 100)
            .padding(.all, 8)

            if !isAddingNew {
                Button("Add New") {
                    withAnimation {
                        isAddingNew = true
                    }
                }
                .padding()
                .transition(.move(edge: .bottom))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
