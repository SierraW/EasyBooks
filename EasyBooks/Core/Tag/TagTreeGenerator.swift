//
//  TagTreeGenerator.swift
//  EasyBooks
//
//  Created by Yiyao Zhang on 2021-04-04.
//

import Foundation

struct TagTreeNode {
    var parent: String?
    var tag: String
    var children: [TagTreeNode]
}

class TagTreeGenerator {
    var root: TagTreeNode?

    func generateTagTree(with tags: [EBTag]){
        var map: [String: [TagTreeNode]] = [:]
        var root = TagTreeNode(parent: nil, tag: "Root", children: [])
        for tag in tags {
            let node = TagTreeNode(parent: tag.parent, tag: tag.name!, children: [])
            if let parent = node.parent {
                if map[parent] == nil {
                    map[parent] = []
                }
                map[parent]!.append(node)
            } else {
                root.children.append(node)
            }
        }
        
        constructTree(node: &root, map: map)
        
        self.root = root
    }
    
    func constructTree(node: inout TagTreeNode, map: [String: [TagTreeNode]]) {
        if let children = map[node.tag] {
            node.children = children
        }
        for i in node.children.indices {
            constructTree(node: &node.children[i], map: map)
        }
    }
    
    func treeToString() -> String {
        var result = ""
        if let root = root {
            for node in root.children {
                result += nodeToString(node: node, depth: 0)
                result += "\n\n\n"
            }
        }
        return result
    }
    
    func nodeToString(node: TagTreeNode, depth: Int) -> String {
        var result = ""
        for _ in 0..<depth {
            result += "\t"
        }
        result += depth == 0 ? node.tag : "> \(node.tag)"
        if node.children.count > 0 {
            for e in node.children {
                result += "\n\(nodeToString(node: e, depth: depth + 1))"
            }
        }
        return result
    }
    
    static func isCyclic(for tag: EBTag, with others: [EBTag]) -> Bool {
        if tag.parent == nil {
            return false
        }
        let set = Set<EBTag>(others)
        var t = tag
        while t.parent != nil {
            if let parent = set.first(where: { ele -> Bool in
                ele.name == t.parent
            }) {
                t = parent
            } else {
                t.parent = nil
            }
            
            if t == tag {
                return true
            }
        }
        return false
    }
}
