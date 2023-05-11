//
//  Category_DB + PersistedModelProtocol.swift
//  CatalogViewer
//
//  Created by Hardijs Ķirsis on 25/03/2023.
//


import DevToolsCore

extension Category_DB: PersistedModelProtocol {
        
   public  enum PersistedField: String, PersistedModelFieldProtocol {
        case id
        case parentID
        case imageURL
        case size
        case title
    }
    
    public func toDomain(fields: Set<PersistedField>) throws -> Category {
        // TODO: Throw errors etc
        return .init(id: self.id, parentID: self.parentID, imageURL: self.imageURL, size: self.size, title: self.title)
    }
    
    public func update(with model: Category, fields: Set<PersistedField>) {
        // TODO: Handle fields if needed
        self.id = model.id
        self.parentID = model.parentID
        self.imageURL = model.imageURL
        self.size = model.size
        self.title = model.title
    }
}
