//
//  Text+.swift
//  PAWKEY
//
//  Created by a on 10/31/25.
//

import SwiftUI

extension Text {
    func header1(color: Color = .contents) -> some View {
        self.font(.header1)
            .foregroundStyle(color)
    }
    
    func header2(color: Color = .contents) -> some View {
        self.font(.header2)
            .foregroundStyle(color)
    }
    
    func header3(color: Color = .contents) -> some View {
        self.font(.header3)
            .foregroundStyle(color)
    }
    
    func subtitle(color: Color = .contents) -> some View {
        self.font(.subtitle)
            .foregroundStyle(color)
    }
    
    func bodyDefault(color: Color = .contents) -> some View {
        self.font(.bodyDefault)
            .foregroundStyle(color)
    }
    
    func bodyActive(color: Color = .contents) -> some View {
        self.font(.bodyActive)
            .foregroundStyle(color)
    }
    
    func bodySmall(color: Color = .contents) -> some View {
        self.font(.bodySmall)
            .foregroundStyle(color)
    }
    
    func mainDefault(color: Color = .contents) -> some View {
        self.font(.mainDefault)
            .foregroundStyle(color)
    }
    
    func subDefault(color: Color = .contents) -> some View {
        self.font(.subDefault)
            .foregroundStyle(color)
    }
    
    func subActive(color: Color = .contents) -> some View {
        self.font(.subActive)
            .foregroundStyle(color)
    }
    
    func small(color: Color = .contents) -> some View {
        self.font(.small)
            .foregroundStyle(color)
    }
    
    func link(color: Color = .contents) -> some View {
        self.font(.link)
            .foregroundStyle(color)
    }
}
