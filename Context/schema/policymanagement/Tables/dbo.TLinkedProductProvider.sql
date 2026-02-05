CREATE TABLE [dbo].[TLinkedProductProvider](
	[LinkedProductProviderId] [int] IDENTITY(1,1) NOT NULL,
	[RefProdProviderId] [int] NOT NULL,
	[LinkedRefProdProviderId] [int] NOT NULL

    CONSTRAINT [PK_TLinkedProductProvider] PRIMARY KEY CLUSTERED ([LinkedProductProviderId]),
    CONSTRAINT [UQ_TLinkedProductProvider_RefProdProviderId_LinkedRefProdProviderId] UNIQUE ([RefProdProviderId], [LinkedRefProdProviderId]),
    CONSTRAINT [FK_TLinkedProductProvider_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES TRefProdProvider([RefProdProviderId]),
    CONSTRAINT [FK_TLinkedProductProvider_LinkedRefProdProviderId] FOREIGN KEY ([LinkedRefProdProviderId]) REFERENCES TRefProdProvider([RefProdProviderId])
)